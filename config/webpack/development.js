process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

// add type checking according to
// https://github.com/rails/webpacker/blob/master/docs/typescript.md
const ForkTsCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin");
const path = require("path");

environment.plugins.append(
  "ForkTsCheckerWebpackPlugin",
  new ForkTsCheckerWebpackPlugin({
    typescript: {
      configFile: path.resolve(__dirname, "../../tsconfig.json"),
    },
    async: false,
  })
);
// \add type checking according to

module.exports = environment.toWebpackConfig()
