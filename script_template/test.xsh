#! /usr/bin/env xonsh
# ar18

import subprocess
import sys

def install(package):
  @(sys.executable) -m pip install @(package)

#################################SCRIPT_START##################################

def test(var):
  echo $var1
  $var4="var4"
  try:
    import json5
  except ModuleNotFoundError:
    install("json5")
    echo shit
  except Exception as e:
    print(e)
  print(var)
  export
  echo foo2@(var) > /tmp/bar
  cat /tmp/bar
  echo y | @(sys.executable) -m pip uninstall json5
  
  source test2/test2.xsh
  echo $var3
  test2()
  echo $var2
  
  #djfs

try:
  $var1 = 'var1'
  test("foo")
  echo $var4
except Exception:
  cleanup()

##################################SCRIPT_END###################################

