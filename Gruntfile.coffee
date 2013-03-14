module.exports = (grunt)->

  @initConfig
    browserify2:
      entry: './test/file.js'
      mount: '/application.js'
      debug: yes
      compile: './build/application.js'
      beforeHook: (bundle)->
        console.log 'in before hook'
      # server: './build/server.js'

  @loadTasks 'tasks'

  @registerTask 'default', ['browserify2']
