module.exports = (grunt) ->
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-sass')
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        watch:
            coffee:
                files: './coffee/*.coffee'
                tasks: ['coffee:compile']
            sass:
                files: './sass/*.sass'
                tasks: ['sass']
        coffee:
            compile:
                expand: true
                flatten: true
                src: './coffee/*.coffee'
                dest: './public/js/compiled/'
                ext: '.js'
        sass:
            dist:
                options:
                    style: 'compressed'
                files:
                    './public/css/compiled/style.css': './sass/*.sass'
