import chalk from 'chalk'
import fs from 'fs'
import { join, resolve } from 'path'

import { getAbsPath, toTrash } from './common.js'

const [suffix = 'jpg'] = process.argv.slice(2)

const remainingList = new Set()

const getFilterNames = dirPath => {
  return fs.readdirSync(dirPath).filter(item => {
    const stat = fs.statSync(join(dirPath, item))
    if (stat.isFile()) {
      const [name, format] = item.split('.')
      if (format.toLowerCase() === suffix.toLowerCase()) {
        return true
      } else {
        remainingList.add(name)
      }
    }
    return false
  })
}

const currentPath = getAbsPath('./')

const filterNames = getFilterNames(currentPath)

console.log(chalk.cyan(`当前目录：${currentPath}`))
console.log(chalk.cyan(`删除前文件个数：${filterNames.length}`))

let count = 0
Promise.all(
  filterNames
    .map(item => {
      const filePath = resolve(currentPath, item)
      const [name] = item.split('.')
      if (!remainingList.has(name)) {
        return toTrash(filePath).then(() => {
          count++
          console.log(chalk.red(`删除文件：${filePath} 到回收站`))
        })
      }
    })
    .flat(),
).then(() => {
  console.log(chalk.green(`同步删除文件完成，删除${count}个文件`))
})
