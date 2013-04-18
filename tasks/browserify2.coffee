path = require 'path'
helper =
  require: (_path)->
    require path.resolve(process.cwd(), _path)

expose = (grunt, bundle, key, val) =>
  if key isnt 'files'
    bundle.require( val, { expose: key } )
  else
    for fileOpts in val
      fileOpts.expand = true
      fileOpts.flatten = true
      fileOpts.dest = fileOpts.dest || ''
      # fileOpts.cwd must be specified
      # fileOpts.src must be specified

      files = grunt.file.expandMapping fileOpts.src, fileOpts.dest, fileOpts
      bundle.require( './' + file.src, { expose: file.dest.substr(0, file.dest.indexOf('.')) } ) for file in files

module.exports = (grunt)->
  @registerMultiTask 'browserify2', 'commonjs modules in the browser', ->
    done = @async()
    browserify = require 'browserify'
    config = grunt.config.get(@name)
    targetConfig = config[@target]

    options = @options @data

    {entry, mount, server, debug, compile, beforeHook, afterHook} = options
    bundle = browserify entry

    exposeOpts = []
    exposeOpts.push targetConfig.options?.expose if targetConfig.options?.expose
    exposeOpts.push config.options?.expose if config.options?.expose
    expose grunt, bundle, key, val for key, val of opt for opt in exposeOpts

    if beforeHook
      beforeHook.call this, bundle

    # build bundle
    bundle.bundle {debug}, (err, src)->
      if err then grunt.log.error err

      if not server and not compile
        grunt.log.error 'either server or compile options must be defined.'
        done()

      if afterHook
        src = afterHook.call this, src

      if server
        time = new Date()
        express_plugin = (req, res, next)->
          if req.url.split('?')[0] is mount
            res.statusCode = 200
            res.setHeader 'last-modified', time
            res.setHeader 'content-type', 'text/javascript'
            res.end(src)
          else
            next()
        app = helper.require server
        app.use express_plugin

      if compile
        grunt.file.write path.resolve(process.cwd(), compile), src
        msg = "File written to: #{grunt.log.wordlist [compile], color: 'cyan'}"
        grunt.log.writeln msg
        done()
