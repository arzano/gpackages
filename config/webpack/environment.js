const { environment } = require('@rails/webpacker')

// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
});

const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery/dist/jquery',
  jQuery: 'jquery/dist/jquery',
  Popper: ['popper.js', 'default']
}))


module.exports = environment
