module.exports = function (w) {

    return {
        files: [
            'app/**/*.ts',
            {pattern: 'app/**/*.spec.ts', ignore: true}
        ],

        tests: [
            'app/**/*.spec.ts'
        ],

        env: {
            type: 'node'
        },

        // you may remove the setting if you have a tsconfig.json file where the same is set
        compilers: {
            '**/*.ts': w.compilers.typeScript()
        }
    };
};