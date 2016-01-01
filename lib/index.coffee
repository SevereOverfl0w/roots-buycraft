Axios = require 'axios'
Url = require 'url'
Path = require 'path'
Hyperstream = require 'hyperstream'
Stream = require 'stream'
Concat = require 'concat-stream'

fixHtml = (url, html) ->
  hs = Hyperstream({
    head:
      _appendHtml: "<%%- css('/') %>"
    'style':
      _html: ''
    '[href^="/templates/"]':
      href: prepend: url
    '[src^="/templates/"]':
      src: prepend: url
  })

  s = new Stream.Readable()
  s.push html
  s.push null

  return new Promise (resolve, reject) ->
    concatStream = Concat (data) ->
      resolve(data.toString())

    strOut = s.pipe(hs).pipe(concatStream)
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
