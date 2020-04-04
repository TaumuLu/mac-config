#!/usr/bin/env python3
import os, sys, getopt, shutil
from pathlib import Path

folder = (
  ('karabiner', '.config'),
  '.hammerspoon',
)

files = (
  '.bash_profile',
  '.bashrc',
  '.gitconfig',
  '.npmrc',
  '.vimrc',
  '.zshrc'
)

HOME = os.environ.get('HOME')
PROJECTROOT = sys.path[0]

opts, args = getopt.getopt(sys.argv[1:], 'df')

def hasOption(option):
  for opt, arg in opts:
    if opt == option:
      return True
  return False

def links(data, basePath):
  for value in data:
    source = [PROJECTROOT, basePath]
    target = [HOME]
    # target = [PROJE`CTROOT, 'test']
    if isinstance(value, tuple):
      s, t = value
      source.append(s)
      target.extend([t, s])
    else:
      source.append(value)
      target.append(value)
    sourcePath = Path(*source)
    targetPath = Path(*target)
    if sourcePath.exists():
      if not targetPath.exists():
        parent = Path(targetPath.parent)
        if not parent.exists():
          os.makedirs(parent)
        targetPath.unlink()
        targetPath.symlink_to(sourcePath)
        pass
      elif targetPath.samefile(sourcePath) and not hasOption('-d'):
        print('链接已创建，无需重复创建: %s' % targetPath)
        pass
      else:
        if targetPath.is_symlink() or hasOption('-f'):
          if targetPath.is_dir():
            shutil.rmtree(targetPath)
          else:
            targetPath.unlink()
            targetPath.symlink_to(sourcePath)
        else:
          print('存在同名文件，无法创建链接: %s' % targetPath)

links(folder, 'configs')
links(files, 'dotfilts')