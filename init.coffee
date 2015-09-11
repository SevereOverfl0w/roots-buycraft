axios = require 'axios'
url = require 'url'

exports.configure = [
  {
    name: 'url'
    message: 'What is your Buycraft URL?'
  },
]

chainer = (config, html) ->
  {
    pipe: (f) ->
      chainer(config, f config, html)
    done: () ->
      html
  }

absoluteURLs = (config, html) ->
  html.replace(/\/templates\//g, url.resolve(config.url, '/templates/'))

injectStyles = (config, html) ->
  html.replace /<\/head>/, (w) ->
    '<%%- css() %>\n' + w

removeInlineStyle = (config, html) ->
  html.replace /<style>.*<\/style>/, ''

fixHtml = (config, html) ->
  chainer config, html
         .pipe injectStyles
         .pipe absoluteURLs
         .pipe removeInlineStyle
         .done()

exports.before = (utils) ->
  # before hook

exports.beforeRender = (utils, config) ->
  # before_render hook
  config.name = url.parse config.url
                   .hostname
                   .split('.')[0]

exports.after = (utils, config) ->
  # after hook
  axios.get config.url
       .then (res) ->
         fixHtml config, res.data
       .then (html) ->
         utils.target.write 'views/index.ejs', html

