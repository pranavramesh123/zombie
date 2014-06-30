module.exports = (grunt) ->
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-sass')
    grunt.loadNpmTasks('grunt-contrib-concat')
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        watch:
            coffee:
                files: './coffee/**/*.coffee'
                tasks: ['coffee:compile']
            concat:
                files: './coffee/**/*.coffee'
                tasks: ['concat']
            sass:
                files: './sass/*.sass'
                tasks: ['sass']
        coffee:
            compile:
                expand: true
                flatten: false
                src: './coffee/**/*.coffee'
                dest: './compiled-js/'
                ext: '.js'
        sass:
            dist:
                options:
                    style: 'compressed'
                files:
                    './public/css/compiled/style.css': './sass/*.sass'
        concat:
            dist:
                src:[
                    './compiled-js/coffee/init.js',
                    './compiled-js/coffee/spritesheets/*.js',
                    './compiled-js/coffee/classes/Utilities.js',
                    './compiled-js/coffee/classes/Timer.js',
                    './compiled-js/coffee/classes/Sprite.js',
                    './compiled-js/coffee/classes/Zombie.js',
                    './compiled-js/coffee/classes/Player.js',
                    './compiled-js/coffee/index.js'
                ]
                dest:
                    './public/js/compiled/game.js'