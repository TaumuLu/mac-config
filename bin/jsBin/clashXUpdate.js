import axios from 'axios'
import chalk from 'chalk'
import fs from 'fs'
import ora from 'ora'
import { parse, stringify } from 'yaml'

const subUrl = process.env.CLASHX_SUB
const myConfigPath = `${process.env.HOME}/Library/Mobile Documents/iCloud~com~west2online~ClashX/Documents/mt.yaml`

if (!fs.existsSync(myConfigPath)) {
  throw new Error(`not found myConfig: ${myConfigPath}`)
}

if (subUrl) {
  console.log(chalk.yellow(`加载远程配置：\n${subUrl}`))
  const spinner = ora(`加载中`).start()

  axios
    .get(subUrl)
    .then(res => {
      spinner.succeed('加载完成')
      const myConfigFile = fs.readFileSync(myConfigPath, 'utf8')
      const myConfig = parse(myConfigFile)
      const config = parse(res.data)
      spinner.succeed('解析完成')

      Object.keys(myConfig).forEach(key => {
        const value = config[key]
        switch (key) {
          // 跳过配置
          case 'rules':
          case 'proxy-groups':
            break
          // const nodeSelect = value.find(item => item.name === '🔰 节点选择')
          // if (nodeSelect) {
          //   console.log('--------', `同步：'🔰 节点选择'`)
          //   myValue[0].proxies = nodeSelect.proxies
          // }
          // const autoSelect = value.find(item => item.name === '♻️ 自动选择')
          // if (autoSelect) {
          //   console.log('--------', `同步：'♻️ 自动选择'`)
          //   myValue[1].proxies = autoSelect.proxies
          // }
          // proxies
          default:
            if (value) {
              console.log('--------', `同步配置：${key}`)
              myConfig[key] = value
            }
            break
        }
      })

      // PROXY config
      myConfig['proxy-groups'][0].proxies = config.proxies.map(
        item => item.name,
      )
      spinner.succeed('配置替换完成')

      // 写入原文件
      const newConfig = stringify(myConfig)
      fs.writeFileSync(myConfigPath, newConfig)
      console.log(chalk.green(`解析完成，请重新加载配置`))
    })
    .catch(error => {
      spinner.fail('加载失败')
      console.log(error)
    })
} else {
  throw new Error(`not found clashX config url: ${subUrl}`)
}
