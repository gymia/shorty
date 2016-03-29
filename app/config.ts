export interface Config {
    name: string,
    port: number,
    env: string,
    version: string
}

var env = process.env.NODE_ENV || 'development';

export let settings: Config = {
    name: 'shorty-typescript',
    version: '1.0.0',
    port: 3000,
    env: 'dev'
};

if (env !== 'development') {
    settings.env = 'prod';
}