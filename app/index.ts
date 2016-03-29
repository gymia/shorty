import restify = require('restify');
import {settings} from './config';
import {InMemoryStorage} from "./storage/inMemoryStorage";
import {ShortcodeGenerator} from "./services/generatorService";
import {ShortcodeService} from "./services/shortcodeService";
import {ShortcodeController} from "./controllers/shortcodeController";
import {StatsController} from "./controllers/statsController";

let api = restify.createServer({
   name: settings.name
});

restify.CORS.ALLOW_HEADERS.push('authorization');
api.use(restify.CORS());
api.pre(restify.pre.sanitizePath());
api.use(restify.acceptParser(api.acceptable));
api.use(restify.bodyParser());
api.use(restify.queryParser());
api.use(restify.authorizationParser());
api.use(restify.fullResponse());

let storage = new InMemoryStorage();
let shortcodeGenerator = new ShortcodeGenerator();
let shortcodeService = new ShortcodeService(storage, shortcodeGenerator);
let shortcodeCtrl = new ShortcodeController(shortcodeService);
let statsCtrl = new StatsController(shortcodeService);

api.post('/shorten', shortcodeCtrl.post.bind(shortcodeCtrl));
api.get('/:shortcode', shortcodeCtrl.get.bind(shortcodeCtrl));
api.get('/:shortcode/stats', statsCtrl.get.bind(statsCtrl));

api.listen(settings.port, function() {
    console.log(`INFO: ${settings.name} is running at ${api.url}`);
});