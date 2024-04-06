import chalk from 'chalk'
import cpy from 'cpy'
import dayjs from 'dayjs'
import fs from 'fs'
import ora from 'ora'
import { join, resolve } from 'path'

const currentYear = dayjs().year()

const [originPath = './', targetPath = `~/Pictures/${currentYear}`] =
  process.argv.slice(2)

const homePath = process.env.HOME

const getAbsPath = (...paths) => {
  return resolve(...paths.map(item => item.replace('~', homePath)))
}

const originPathAbs = getAbsPath(originPath)
const targetPathAbs = getAbsPath(targetPath)

if (!fs.existsSync(targetPathAbs)) {
  console.log(chalk.blue('不存在文件夹，创建文件夹：', targetPathAbs))
  fs.mkdirSync(targetPathAbs)
}

fs.readdirSync(originPathAbs).map(item => {
  const itemPath = join(originPathAbs, item)
  const stats = fs.statSync(itemPath)
  const folderName = dayjs(stats.birthtime).format('YYYY-MM-DD')

  const movePath = join(targetPathAbs, folderName)

  if (fs.existsSync(movePath)) {
    console.log(chalk.yellow('已存在文件夹：', movePath))
  } else {
    const spinner = ora(`复制文件`).start()
    cpy(itemPath, movePath).then(() => {
      spinner.succeed('复制完成')
      console.log(chalk.green(`复制文件夹：${itemPath} -> ${movePath}`))
    })
  }
})
