const { environment } = require('@rails/webpacker');
const webpack = require('webpack');
const customConfig = require('./custom.js');
environment.config.merge(customConfig);

module.exports = environment;

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $:      'jquery',
    jQuery: 'jquery',
    jquery: 'jquery'
  })
)
