module.exports = function(grunt) {
    grunt.initConfig({
        uglify: {
            build: {
                src: ['web-app/BigWheel/zp.js'],
                dest: 'web-app/BigWheel/zp.min.js'
            }
        } 
    });
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.registerTask('default', ['uglify']);
};
