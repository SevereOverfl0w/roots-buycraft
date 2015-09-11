lib = require '../lib'
url = require 'url'

module.exports = (utils, base, id) ->
  output = '/category/' + id
  lib.createPage utils, url.resolve(base, output), output, true
