const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery'
    })
)

const handlebars = require('./loaders/handlebars')
environment.loaders.prepend('handlebars',handlebars)

module.exports = environment
