// vue.config.js
module.exports = {
  devServer: {
    port: 8082,
    proxy: {
      '/': {
        target: 'http://localhost:9000',
        changeOrigin: true,
        secure: false,
        // 排除不需要代理的请求（如静态资源）
        bypass: function(req, res, proxyOptions) {
          if (req.headers.accept.indexOf('html') !== -1) {
            return '/index.html'
          }
        }
      }
    }
  }
}
