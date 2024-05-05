import { exec } from 'child_process'
import { resolve } from 'path'

export const execAsync = command => {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        reject(error)
      } else if (stderr) {
        reject(stderr)
      } else {
        resolve()
      }
    })
  })
}

export const mvFile = (currentPath, targetPath) => {
  return execAsync(
    `mv ${currentPath.replace(/\s/g, '\\' + ' ')} ${targetPath.replace(/\s/g, '\\' + ' ')}`,
  )
}

const trashDirectory = '~/.Trash'

export const toTrash = filePath => {
  return mvFile(filePath, trashDirectory)
}

export const homePath = process.env.HOME

export const getAbsPath = (...paths) => {
  return resolve(...paths.map(item => item.replace('~', homePath)))
}
