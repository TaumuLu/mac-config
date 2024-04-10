import { exec } from 'child_process'

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

const trashDirectory = '~/.Trash'

export const toTrash = filePath => {
  return execAsync(`mv "${filePath}" ${trashDirectory}`)
}
