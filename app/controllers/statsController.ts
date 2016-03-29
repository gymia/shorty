import restify = require('restify');
import {ShortcodeService} from "../services/shortcodeService";
import {ShortcodeStats} from "../models/shortcodeStats";

export class StatsController{
    constructor(private shortcodeService: ShortcodeService){

    }

    get(req: restify.Request, res: restify.Response, next: restify.Next){
        let stats: ShortcodeStats = this.shortcodeService.getStats(req.params.shortcode);

        if (stats) {
            let output: {startDate: string, redirectCount: Number, lastSeenDate?: string} = {
                startDate: stats.startDate.toISOString(),
                redirectCount: stats.redirectCount
            };

            if(stats.redirectCount > 0){
                output.lastSeenDate = stats.lastSeenDate.toISOString();
            }

            res.json(200, output);
        } else {
            res.json(404);
        }

        return next();
    }
}