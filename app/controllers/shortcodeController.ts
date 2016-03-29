import restify = require('restify');
import {ShortcodeService} from '../services/shortcodeService';
import {ShortcodeExistsError} from "../errors/shortcodeExistsError";

export class ShortcodeController {
    constructor(private shortcodeService: ShortcodeService){
    }

    post(req: restify.Request, res: restify.Response, next: restify.Next) {
        let shortcode: string;
        if (!req.body.url) {
            res.json(400, {message: 'url is not present'});
            return next();
        }

        if (req.body.shortcode) {
            if (!req.body.shortcode.match(/^[0-9a-zA-Z_]{4,}$/)) {
                res.json(422, {message: 'The provided shortcode is invalid, it should match "/^[0-9a-zA-Z_]{4,}$/"'});
                return next();
            }

            shortcode = req.body.shortcode;
        }

        try{
            shortcode = this.shortcodeService.save(req.body.url, shortcode);

            res.json(201, {shortcode: shortcode});
        }catch(e){
            if(e instanceof ShortcodeExistsError){
                res.json(409, {message: 'The desired shortcode is already in use.', error: e});
            }else{
                res.json(500, {error: e});
            }
        }

        return next();
    }

    get(req: restify.Request, res: restify.Response, next: restify.Next){
        let location = this.shortcodeService.get(req.params.shortcode);

        if (location) {
            res.send(302, null, {location});
            this.shortcodeService.updateUsage(req.params.shortcode);
        } else {
            res.send(404);
        }

        return next();
    }
}