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
  '.zshrc'
  # '.vimrc',
)

HOME = Path.home()
PROJECTROOT = Path.cwd()

opts, args = getopt.getopt(sys.argv[1:], 'if')

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
        if targetPath.is_symlink():
          targetPath.unlink()
        targetPath.symlink_to(sourcePath)
        pass
      elif targetPath.samefile(sourcePath) and not hasOption('-i'):
        print('The link has been created, no need to create it again: %s' % targetPath)
        pass
      else:
        if targetPath.is_symlink() or hasOption('-f'):
          if targetPath.is_dir() and not targetPath.is_symlink():
            shutil.rmtree(targetPath)
          else:
            targetPath.unlink()
            targetPath.symlink_to(sourcePath)
        else:
          print('There is a file with the same name and the link cannot be created: %s' % targetPath)

links(folder, 'configs')
links(files, 'dotfilts')