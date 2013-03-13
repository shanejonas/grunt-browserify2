fs = require 'fs'
path = require 'path'

module.exports = (grunt)->
  @registerTask 'browserify2', 'commonjs modulez', ->
    required = ['entry', 'mount']
    done = @async()
    browserify = require 'browserify'
    {entry, mount, server, debug, compile} = grunt.config.get(@name)
    bundle = browserify entry
    grunt.config.requires("#{@name}.#{r}") for r in required

    # build bundle
    bundle.bundle {debug}, (err, src)->

      if not server and not compile
        grunt.log.error('either server or compile options must be defined.')
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
        app = require(path.resolve server)
        app.use express_plugin

      if compile then fs.writeFile compile, src, (err)->
        done()
