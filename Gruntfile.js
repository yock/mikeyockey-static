module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    sass: {
      options: {
        includePaths: ['bower_components/foundation/scss']
      },
      dist: {
        options: {
          outputStyle: 'compressed'
        },
        files: {
          'css/app.css': 'scss/app.scss'
        }        
      }
    },
    copy: {
      main: {
        files: [
          { expand: true, src: ['css/*', 'fonts/*', 'img/*', 'js/*', '*.txt', '*.html'], dest: 'dist/' },
        ]
      }
    },

    watch: {
      grunt: { files: ['Gruntfile.js'] },

      sass: {
        files: 'scss/**/*.scss',
        tasks: ['sass'],
        options: {
          livereload: true
        },
      },

      html: {
        files: '**/*.html',
        options: {
          livereload: true
        }
      }
    },

    connect: {
      server: {
        options: {
          port: 9000,
          base: '.'
        }
      }
    },

    clean: ['dist']
  });

  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');

  grunt.registerTask('build', ['clean', 'sass', 'copy']);
  grunt.registerTask('default', ['build','watch']);
  grunt.registerTask('server', ['build', 'connect', 'watch']);
}
