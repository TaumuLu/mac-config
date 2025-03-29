// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

const defaultBrowser = 'Google Chrome'
const larkBrowser = 'Google Chrome Beta'

module.exports = {
  defaultBrowser,
  options: {
    hideIcon: false,
    checkForUpdate: true,
    logRequests: false,
  },
  handlers: [
    {
      match: ({ opener }) => {
        // finicky.log(opener.bundleId);
        // com.electron.lark
        return opener.bundleId === 'com.larksuite.larkApp'
      },
      browser: larkBrowser,
    },
    {
      match: params => {
        const { url } = params
        // finicky.log(url.host);
        return ['smqwe.com', 'larksuite.com'].some(host =>
          url.host.includes(host),
        )
      },
      browser: larkBrowser,
    },
    {
      match: params => {
        const { url } = params
        return ['localhost', '127.0.0.1'].some(host => url.host.includes(host))
      },
      browser: defaultBrowser,
    },
  ],
  rewrite: [
    {
      match: ({ url }) => url.host.endsWith('zentao2.siyecao1.com'),
      url: params => {
        // finicky.log(JSON.stringify(params));
        const { url } = params
        return {
          ...url,
          host: 'zentao2.smqwe.com',
          protocol: 'http',
        }
      },
    },
  ],
}
