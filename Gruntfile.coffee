module.exports = (grunt) ->

  grunt.initConfig

    watch:
      browserify:
        files: ['lib/**/*.coffee', 'test/**/*.coffee']
        tasks: ['browserify']
      coffee:
        files: ['app.coffee']
        tasks: ['coffee']

    browserify:
      dev:
        src: ['lib/index.coffee']
        dest: 'dist/fusen-editor.js'
        options:
          debug: on
      unit:
        src: ['test/index.coffee']
        dest: 'test/fusen-editor-test.js'
        options:
          debug: true
      options:
        transform: ['coffeeify']
        shim:
          jQuery:
            path: 'node_modules/jquery-browserify/lib/jquery.js'
            exports: '$'
          'svg.js':
            path: 'vendor/bower_components/svg.js/dist/svg.js'
            exports: 'SVG'
          'svg.draggable.js':
            path: 'vendor/svg.draggable.js.git/svg.draggable.js'
            exports: 'SVG'

    coffee:
      dev_server:
        src: ['app.coffee']
        dest: 'app.js'

  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
