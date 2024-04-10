import chalk from 'chalk'
import fs from 'fs'
import { join, resolve } from 'path'

import { toTrash } from './common.js'

const [pwaPath = './', rawPath = './raw', ...otherPath] = process.argv.slice(2)

const isForce = otherPath.includes('-f')

const getFileNames = dirPath => {
  return fs
    .readdirSync(dirPath)
    .filter(item => {
      const stat = fs.statSync(join(dirPath, item))
      return stat.isFile()
    })
    .map(item => {
      const [name] = item.split('.')
      return name
    })
}

const crossPathList = [pwaPath, rawPath]
  .map(p => resolve(p))
  .filter(p => fs.existsSync(p))

const crossFileNames = isForce
  ? crossPathList.reduce((p, c) => {
      const names = getFileNames(c)
      if (p.length === 0) {
        return names
      } else {
        return p.filter(name => names.includes(name))
      }
    }, [])
  : getFileNames(pwaPath)

console.log(chalk.blue(`同步目录：`))
console.log(chalk.blue(crossPathList.join('\n')))

console.log(chalk.cyan(`是否交叉所有目录：${isForce}`))
console.log(chalk.cyan(`交叉文件个数：${crossFileNames.length}`))

let count = 0
Promise.all(
  crossPathList
    .map(dirPath => {
      return fs.readdirSync(dirPath).map(item => {
        const filePath = resolve(dirPath, item)
        const stat = fs.statSync(filePath)

        if (stat.isFile()) {
          const [name] = item.split('.')
          if (!crossFileNames.includes(name)) {
            return toTrash(filePath).then(() => {
              count++
              console.log(chalk.red(`删除文件：${filePath} 到回收站`))
            })
          }
        }
      })
    })
    .flat(),
).then(() => {
  console.log(chalk.green(`同步交叉文件完成，删除${count}个文件`))
})
