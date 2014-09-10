module.exports = (grunt) ->
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-sass')
    grunt.loadNpmTasks('grunt-contrib-concat')
    grunt.loadNpmTasks('grunt-contrib-copy')
    grunt.loadNpmTasks('grunt-contrib-uglify')
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
            copy:
                files: './coffee/workers/**/*.coffee'
                tasks: ['copy:workers']
        coffee:
            compile:
                expand: true
                flatten: false
                src: './coffee/**/*.coffee'
                dest: './compiled-js/'
                ext: '.js'
        copy:
            workers:
                expand: true
                flatten: true
                src: './compiled-js/coffee/workers/**/*.js'
                dest: './public/js/compiled/workers/'
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
                    './compiled-js/coffee/classes/Game.js',
                    './compiled-js/coffee/spritesheets/*.js',
                    './compiled-js/coffee/classes/Utilities.js',
                    './compiled-js/coffee/classes/Timer.js',
                    './compiled-js/coffee/classes/Sprite.js',
                    './compiled-js/coffee/classes/Zombie.js',
                    './compiled-js/coffee/classes/Player.js',
                    './compiled-js/coffee/interact.js'
                ]
                dest:
                    './public/js/compiled/game.js'
        uglify:
            options:
                banner: "/* Copyright 2014 Greg Weston */\n"
            dist:
                files: [{
                    expand: true
                    cwd: './public/js/compiled/'
                    src: '**/*.js'
                    dest: './public/js/compiled/'
                }]