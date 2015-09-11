url = require 'url'
lib = require './lib'

exports.configure = [
  {
    name: 'url'
    message: 'What is your Buycraft URL?'
  },
]

exports.before = (utils) ->
  # before hook

exports.beforeRender = (utils, config) ->
  # before_render hook
  config.name = url.parse config.url
                   .hostname
                   .split('.')[0]

exports.after = (utils, config) ->
  # after hook
  lib.createPage utils, config.url, 'index'
  
