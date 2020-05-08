#!/usr/bin/env python3
import os, sys, getopt, shutil
from pathlib import Path

HOME = Path.home()
PROJECTROOT = Path.cwd()

folder = (
  ('karabiner', '.config'),
  '.hammerspoon',
  '.SwitchHosts',
)

files = (
  ('proxychains.conf', '/usr/local/etc'),
  '.bash_profile',
  '.bashrc',
  '.gitconfig',
  '.npmrc',
  '.zshrc',
  # '.vimrc',
)

documentsPath = HOME.joinpath('Documents/Preferences')
libraryPath = HOME.joinpath('Library/Preferences')
documents = ()

for file in os.listdir(documentsPath):
  source = documentsPath.joinpath(file)
  if source.is_file():
    pathTup = (file,)
    documents += pathTup

opts, args = getopt.getopt(sys.argv[1:], 'if')

def hasOption(option):
  for opt, arg in opts:
    if opt == option:
      return True
  return False

def links(data, sBase=[PROJECTROOT], tBase=[HOME]):
  for value in data:
    source = sBase.copy()
    target = tBase.copy()
    # target = [PROJE`CTROOT, 'test']
    if isinstance(value, tuple):
      s, t = value
      if s.startswith('/'):
        source = [s]
      else:
        source.append(s)
      if t.startswith('/'):
        target = [t, s]
      else:
        target.extend([t, s])
    else:
      if value.startswith('/'):
        source = [value]
        target = [value]
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
        print('Has been created: %s' % targetPath)
        pass
      else:
        if targetPath.is_symlink() or hasOption('-f'):
          if targetPath.is_dir() and not targetPath.is_symlink():
            shutil.rmtree(targetPath)
          else:
            targetPath.unlink()
            targetPath.symlink_to(sourcePath)
        else:
          print('\033[0;33;40mFile with the same name: %s\033[0m' % targetPath)
    else:
      print('\033[0;31;40mNot find file: %s\033[0m' % sourcePath)
      pass

links(folder, [PROJECTROOT, 'configs'])
links(files, [PROJECTROOT, 'dotfilts'])

links(documents, [documentsPath], [libraryPath])
