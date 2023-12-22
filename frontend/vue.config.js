// vue.config.js
module.exports = {
    devServer: {
        host: '0.0.0.0',
        public: '0.0.0.0:80',
        disableHostCheck: true,
        watchOptions: {
            ignored: /node_modules/,
            aggregateTimeout: 300,
            poll: 500
        }
    }
}