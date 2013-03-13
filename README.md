# grunt-browserify2

> a grunt task that uses browserify v2 and optionally express

## Getting Started
This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-browserify2 --save-dev
```

One the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-browserify2');
```

## The "browserify2" task

### Overview
In your project's Gruntfile, add a section named `browserify2` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  browserify2: {
    entry: './build/entry.js',
    mount: '/application.js',
    server: './build/server.js',
    debug: true,
    compile: './public/application.js'
  }
})
```

### Options

#### entry
Type: `String`
Default value: `'.'`

A string value that is used to determine the entry file for browserify

#### mount
Type: `String`
Default value: `'.'`

A string value that is used to determine where to mount your file in express.

#### compile
Type: `String`
Default value: `'.'`

A string value that is used to determine where to save your output file
from browserify. if the `server` option is specified then it will create an
express server and compile the file.

#### debug
Type: `Boolean`
Default value: `false`

A boolean value that determines whether to include source maps for debugging


## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).
