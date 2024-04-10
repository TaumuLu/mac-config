import chalk from 'chalk'
import cpy from 'cpy'
import dayjs from 'dayjs'
import fs from 'fs'
import ora from 'ora'
import { extname, join, resolve } from 'path'

import { execAsync } from './common.js'

const [originPath = './', noClassExt = '.jpg'] = process.argv.slice(2)

const homePath = process.env.HOME

const getAbsPath = (...paths) => {
  return resolve(...paths.map(item => item.replace('~', homePath)))
}

const currentPathAbs = getAbsPath(originPath)
const noClassExts = noClassExt.split(',').map(item => item.trim().toLowerCase())

console.log(chalk.blue('分类文件夹：', currentPathAbs))
console.log(chalk.blue('不分类后缀：', noClassExts))

const extMap = {
  arw: 'raw',
  raf: 'raw',
}

fs.readdirSync(currentPathAbs).map(item => {
  const itemPath = join(currentPathAbs, item)
  const ext = extname(itemPath).toLowerCase()
  const stats = fs.statSync(itemPath)
  if (!stats.isFile()) return

  if (ext) {
    if (!noClassExts.includes(ext)) {
      const key = ext.slice(1)
      const name = extMap[key] || key
      const extPath = join(currentPathAbs, name)
      if (!fs.existsSync(extPath)) {
        console.log(chalk.yellow(`不存在文创建件夹: ${name}`))
        fs.mkdirSync(extPath)
      }
      const targetPath = join(currentPathAbs, name, item)
      execAsync(`mv "${itemPath}" ${targetPath}`).then(() => {
        console.log(chalk.yellow(`移动文件: ${item} -> ${name}`))
      })
    } else {
      console.log(chalk.gray(`排除后缀文件: ${itemPath}`))
    }
  } else {
    console.log(chalk.yellow(`未找到文件后缀: ${itemPath}`))
  }
})

console.log(chalk.green('分类完成'))
