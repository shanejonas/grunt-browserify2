path = require 'path'
helper =
  require: (_path)->
    require path.resolve(process.cwd(), _path)

module.exports = (grunt)->
  @registerMultiTask 'browserify2', 'commonjs modules in the browser', ->
    done = @async()
    browserify = require 'browserify'
    config = grunt.config.get(@name)
    targetConfig = config[@target]
    {entry, mount, server, debug, compile, beforeHook} = targetConfig
    bundle = browserify path.resolve(process.cwd(), entry)
    grunt.config.requires("#{@name}.#{@target}.entry")

    if beforeHook
      beforeHook.call this, bundle

    # build bundle
    bundle.bundle {debug}, (err, src)->
      if err? then grunt.log.error err

      if not server and not compile
        grunt.log.error 'either server or compile options must be defined.'
        done()

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
