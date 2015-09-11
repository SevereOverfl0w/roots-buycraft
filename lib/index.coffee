Axios = require 'axios'
Url = require 'url'
Path = require 'path'

chainer = (url, html) ->
  {
    pipe: (f) ->
      chainer(url, f url, html)
    done: () ->
      html
  }

absoluteURLs = (url, html) ->
  html.replace(/\/templates\//g, Url.resolve(url, '/templates/'))

injectStyles = (url, html) ->
  html.replace /<\/head>/, (w) ->
    "<%%- css('/') %>\n" + w

removeInlineStyle = (url, html) ->
  html.replace /<style>.*<\/style>/, ''

fixHtml = (url, html) ->
  chainer url, html
         .pipe injectStyles
         .pipe absoluteURLs
         .pipe removeInlineStyle
         .done()

exports.createPage = (utils, url, filename, login=false) ->
  outputPath = Path.join 'views/', filename + '.ejs'
  Axios(
        method: if login then "post" else "get"
        url: url
        data: if login then 'ign=Notch')
       .then (res) ->
         fixHtml url, res.data
       .then (html) ->
         utils.target.write outputPath, html
