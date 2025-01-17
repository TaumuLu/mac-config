// Use https://finicky-kickstart.now.sh to generate basic configuration
// Learn more about configuration options: https://github.com/johnste/finicky/wiki/Configuration

module.exports = {
  defaultBrowser: "Google Chrome",
  options: {
    hideIcon: false,
    checkForUpdate: true,
    logRequests: false
  },
  handlers: [
    {
      match: ({ opener }) => {
        // finicky.log(opener.bundleId);
        // com.electron.lark
        return opener.bundleId === "com.larksuite.larkApp"
      },
      browser: "Google Chrome Canary",
    }
  ]
}
