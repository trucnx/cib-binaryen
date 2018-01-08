#!/usr/bin/env python

import os, sys, subprocess, difflib

from scripts.test.support import run_command, split_wast
from scripts.test.shared import (
    ASM2WASM, MOZJS, S2WASM, WASM_SHELL, WASM_OPT, WASM_AS, WASM_DIS,
    WASM_CTOR_EVAL, WASM_MERGE, WASM_REDUCE, WASM2ASM, WASM_METADCE,
    BINARYEN_INSTALL_DIR, has_shell_timeout)
from scripts.test.wasm2asm import tests, spec_tests, extra_tests, assert_tests

print '[ processing and updating testcases... ]\n'

for asm in sorted(os.listdir('test')):
  if asm.endswith('.asm.js'):
    for precise in [0, 1, 2]:
      for opts in [1, 0]:
        cmd = ASM2WASM + [os.path.join('test', asm), '--enable-threads']
        wasm = asm.replace('.asm.js', '.fromasm')
        if not precise:
          cmd += ['--trap-mode=allow', '--ignore-implicit-traps']
          wasm += '.imprecise'
        elif precise == 2:
          cmd += ['--trap-mode=clamp']
          wasm += '.clamp'
        if not opts:
          wasm += '.no-opts'
          if precise:
            cmd += ['-O0'] # test that -O0 does nothing
        else:
          cmd += ['-O']
        if 'debugInfo' in asm:
          cmd += ['-g']
        if 'noffi' in asm:
          cmd += ['--no-legalize-javascript-ffi']
        if precise and opts:
          # test mem init importing
          open('a.mem', 'wb').write(asm)
          cmd += ['--mem-init=a.mem']
          if asm[0] == 'e':
            cmd += ['--mem-base=1024']
        if 'i64' in asm or 'wasm-only' in asm or 'noffi' in asm:
          cmd += ['--wasm-only']
        print ' '.join(cmd)
        actual = run_command(cmd)
        with open(os.path.join('test', wasm), 'w') as o: o.write(actual)
        if 'debugInfo' in asm:
          cmd += ['--source-map', os.path.join('test', wasm + '.map'), '-o', 'a.wasm']
          run_command(cmd)

extension_arg_map = {
  '.wast': [],
  '.clamp.wast': ['--trap-mode=clamp'],
  '.js.wast': ['--trap-mode=js'],
}
for dot_s_dir in ['dot_s', 'llvm_autogenerated']:
  for s in sorted(os.listdir(os.path.join('test', dot_s_dir))):
    if not s.endswith('.s'): continue
    print '..', s
    for ext, ext_args in extension_arg_map.iteritems():
      wasm = s.replace('.s', ext)
      expected_file = os.path.join('test', dot_s_dir, wasm)
      if ext != '.wast' and not os.path.exists(expected_file):
        continue

      full = os.path.join('test', dot_s_dir, s)
      stack_alloc = ['--allocate-stack=1024'] if dot_s_dir == 'llvm_autogenerated' else []
      cmd = S2WASM + [full, '--emscripten-glue'] + stack_alloc + ext_args
      if s.startswith('start_'):
        cmd.append('--start')
      actual = run_command(cmd, stderr=subprocess.PIPE, expected_err='')

      with open(expected_file, 'w') as o: o.write(actual)

for t in sorted(os.listdir(os.path.join('test', 'print'))):
  if t.endswith('.wast'):
    print '..', t
    wasm = os.path.basename(t).replace('.wast', '')
    cmd = WASM_OPT + [os.path.join('test', 'print', t), '--print']
    print '    ', ' '.join(cmd)
    actual = subprocess.check_output(cmd)
    print cmd, actual
    with open(os.path.join('test', 'print', wasm + '.txt'), 'w') as o: o.write(actual)
    cmd = WASM_OPT + [os.path.join('test', 'print', t), '--print-minified']
    print '    ', ' '.join(cmd)
    actual = subprocess.check_output(cmd)
    with open(os.path.join('test', 'print', wasm + '.minified.txt'), 'w') as o: o.write(actual)

for t in sorted(os.listdir(os.path.join('test', 'passes'))):
  if t.endswith(('.wast', '.wasm')):
    print '..', t
    binary = '.wasm' in t
    passname = os.path.basename(t).replace('.wast', '').replace('.wasm', '')
    opts = [('--' + p if not p.startswith('O') else '-' + p) for p in passname.split('_')]
    t = os.path.join('test', 'passes', t)
    actual = ''
    for module, asserts in split_wast(t):
      assert len(asserts) == 0
      with open('split.wast', 'w') as o: o.write(module)
      cmd = WASM_OPT + opts + ['split.wast', '--print']
      actual += run_command(cmd)
    with open(os.path.join('test', 'passes', passname + ('.bin' if binary else '') + '.txt'), 'w') as o: o.write(actual)
    if 'emit-js-wrapper' in t:
      with open('a.js') as i:
        with open(t + '.js', 'w') as o:
          o.write(i.read())
    if 'emit-spec-wrapper' in t:
      with open('a.wat') as i:
        with open(t + '.wat', 'w') as o:
          o.write(i.read())

print '\n[ checking wasm-opt -o notation... ]\n'

wast = os.path.join('test', 'hello_world.wast')
cmd = WASM_OPT + [wast, '-o', 'a.wast', '-S']
run_command(cmd)
open(wast, 'w').write(open('a.wast').read())

print '\n[ checking binary format testcases... ]\n'

for wast in sorted(os.listdir('test')):
  if wast.endswith('.wast') and not wast in []: # blacklist some known failures
    for debug_info in [0, 1]:
      cmd = WASM_AS + [os.path.join('test', wast), '-o', 'a.wasm']
      if debug_info: cmd += ['-g']
      print ' '.join(cmd)
      if os.path.exists('a.wasm'): os.unlink('a.wasm')
      subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      assert os.path.exists('a.wasm')

      cmd = WASM_DIS + ['a.wasm', '-o', 'a.wast']
      print ' '.join(cmd)
      if os.path.exists('a.wast'): os.unlink('a.wast')
      subprocess.check_call(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      assert os.path.exists('a.wast')
      actual = open('a.wast').read()
      binary_name = wast + '.fromBinary'
      if not debug_info: binary_name += '.noDebugInfo'
      with open(os.path.join('test', binary_name), 'w') as o: o.write(actual)

print '\n[ checking example testcases... ]\n'

for t in sorted(os.listdir(os.path.join('test', 'example'))):
  output_file = os.path.join('bin', 'example')
  libdir = os.path.join(BINARYEN_INSTALL_DIR, 'lib')
  cmd = ['-Isrc', '-g', '-lasmjs', '-lsupport', '-L' + libdir, '-pthread', '-o', output_file]
  if t.endswith('.txt'):
    # check if there is a trace in the file, if so, we should build it
    out = subprocess.Popen([os.path.join('scripts', 'clean_c_api_trace.py'), os.path.join('test', 'example', t)], stdout=subprocess.PIPE).communicate()[0]
    if len(out) == 0:
      print '  (no trace in ', t, ')'
      continue
    print '  (will check trace in ', t, ')'
    src = 'trace.cpp'
    with open(src, 'w') as o: o.write(out)
    expected = os.path.join('test', 'example', t + '.txt')
  else:
    src = os.path.join('test', 'example', t)
    expected = os.path.join('test', 'example', '.'.join(t.split('.')[:-1]) + '.txt')
  if not src.endswith(('.c', '.cpp')):
    continue
  # build the C file separately
  extra = [os.environ.get('CC') or 'gcc',
           src, '-c', '-o', 'example.o',
           '-Isrc', '-g', '-L' + libdir, '-pthread']
  print 'build: ', ' '.join(extra)
  print os.getcwd()
  subprocess.check_call(extra)
  # Link against the binaryen C library DSO, using rpath
  cmd = ['example.o', '-lbinaryen', '-Wl,-rpath=' + os.path.abspath(libdir)] + cmd
  print '  ', t, src, expected
  if os.environ.get('COMPILER_FLAGS'):
    for f in os.environ.get('COMPILER_FLAGS').split(' '):
      cmd.append(f)
  cmd = [os.environ.get('CXX') or 'g++', '-std=c++11'] + cmd
  try:
    print 'link: ', ' '.join(cmd)
    subprocess.check_call(cmd)
    print 'run...', output_file
    proc = subprocess.Popen([output_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    actual, err = proc.communicate()
    assert proc.returncode == 0, [proc.returncode, actual, err]
    with open(expected, 'w') as o: o.write(actual)
  finally:
    os.remove(output_file)
    if sys.platform == 'darwin':
      # Also removes debug directory produced on Mac OS
      shutil.rmtree(output_file + '.dSYM')

print '\n[ checking wasm-opt testcases... ]\n'

for t in os.listdir('test'):
  if t.endswith('.wast') and not t.startswith('spec'):
    print '..', t
    t = os.path.join('test', t)
    f = t + '.from-wast'
    cmd = WASM_OPT + [t, '--print']
    actual = run_command(cmd)
    actual = actual.replace('printing before:\n', '')
    open(f, 'w').write(actual)

print '\n[ checking wasm-dis on provided binaries... ]\n'

for t in os.listdir('test'):
  if t.endswith('.wasm') and not t.startswith('spec'):
    print '..', t
    t = os.path.join('test', t)
    cmd = WASM_DIS + [t]
    if os.path.isfile(t + '.map'): cmd += ['--source-map', t + '.map']
    actual = run_command(cmd)

    open(t + '.fromBinary', 'w').write(actual)

print '\n[ checking wasm-merge... ]\n'

for t in os.listdir(os.path.join('test', 'merge')):
  if t.endswith(('.wast', '.wasm')):
    print '..', t
    t = os.path.join('test', 'merge', t)
    u = t + '.toMerge'
    for finalize in [0, 1]:
      for opt in [0, 1]:
        cmd = WASM_MERGE + [t, u, '-o', 'a.wast', '-S', '--verbose']
        if finalize: cmd += ['--finalize-memory-base=1024', '--finalize-table-base=8']
        if opt: cmd += ['-O']
        stdout = run_command(cmd)
        actual = open('a.wast').read()
        out = t + '.combined'
        if finalize: out += '.finalized'
        if opt: out += '.opt'
        with open(out, 'w') as o: o.write(actual)
        with open(out + '.stdout', 'w') as o: o.write(stdout)

if MOZJS:
  print '\n[ checking binaryen.js testcases... ]\n'

  for s in sorted(os.listdir(os.path.join('test', 'binaryen.js'))):
    if not s.endswith('.js'): continue
    print s
    f = open('a.js', 'w')
    f.write(open(os.path.join('bin', 'binaryen.js')).read())
    # node/shell test support
    f.write(open(os.path.join('test', 'binaryen.js', s)).read())
    f.close()
    cmd = [MOZJS, 'a.js']
    out = run_command(cmd, stderr=subprocess.STDOUT)
    with open(os.path.join('test', 'binaryen.js', s + '.txt'), 'w') as o: o.write(out)

print '\n[ checking wasm-ctor-eval... ]\n'

for t in os.listdir(os.path.join('test', 'ctor-eval')):
  if t.endswith(('.wast', '.wasm')):
    print '..', t
    t = os.path.join('test', 'ctor-eval', t)
    ctors = open(t + '.ctors').read().strip()
    cmd = WASM_CTOR_EVAL + [t, '-o', 'a.wast', '-S', '--ctors', ctors]
    stdout = run_command(cmd)
    actual = open('a.wast').read()
    out = t + '.out'
    with open(out, 'w') as o: o.write(actual)

print '\n[ checking wasm2asm ]\n'

for wasm in tests + spec_tests + extra_tests:
  if not wasm.endswith('.wast'):
    continue

  asm = os.path.basename(wasm).replace('.wast', '.2asm.js')
  expected_file = os.path.join('test', asm)

  if not os.path.exists(expected_file):
    continue

  print '..', wasm

  cmd = WASM2ASM + [os.path.join('test', wasm)]
  out = run_command(cmd)
  with open(expected_file, 'w') as o: o.write(out)

for wasm in assert_tests:
  print '..', wasm

  asserts = os.path.basename(wasm).replace('.wast.asserts', '.asserts.js')
  traps = os.path.basename(wasm).replace('.wast.asserts', '.traps.js')
  asserts_expected_file = os.path.join('test', asserts)
  traps_expected_file = os.path.join('test', traps)

  cmd = WASM2ASM + [os.path.join('test', wasm), '--allow-asserts']
  out = run_command(cmd)
  with open(asserts_expected_file, 'w') as o: o.write(out)

  cmd += ['--pedantic']
  out = run_command(cmd)
  with open(traps_expected_file, 'w') as o: o.write(out)

print '\n[ checking wasm-metadce... ]\n'

for t in os.listdir(os.path.join('test', 'metadce')):
  if t.endswith(('.wast', '.wasm')):
    print '..', t
    t = os.path.join('test', 'metadce', t)
    graph = t + '.graph.txt'
    cmd = WASM_METADCE + [t, '--graph-file=' + graph, '-o', 'a.wast', '-S']
    stdout = run_command(cmd)
    actual = open('a.wast').read()
    out = t + '.dced'
    with open(out, 'w') as o: o.write(actual)
    with open(out + '.stdout', 'w') as o: o.write(stdout)

if has_shell_timeout():
  print '\n[ checking wasm-reduce ]\n'

  for t in os.listdir(os.path.join('test', 'reduce')):
    if t.endswith('.wast'):
      print '..', t
      t = os.path.join('test', 'reduce', t)
      # convert to wasm
      run_command(WASM_AS + [t, '-o', 'a.wasm'])
      print run_command(WASM_REDUCE + ['a.wasm', '--command=bin/wasm-opt b.wasm --fuzz-exec', '-t', 'b.wasm', '-w', 'c.wasm'])
      expected = t + '.txt'
      run_command(WASM_DIS + ['c.wasm', '-o', expected])

print '\n[ success! ]'  
