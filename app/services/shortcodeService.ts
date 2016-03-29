import {IStorage} from "../storage/iStorage";
import {ShortcodeGenerator} from "./generatorService";
import {ShortcodeExistsError} from "../errors/shortcodeExistsError";
import {ShortcodeStats} from "../models/shortcodeStats";
export class ShortcodeService {
    constructor(private storage: IStorage, private shortcodeGenerator: ShortcodeGenerator){

    }

    get(shortcode: string): string {
        return this.storage.getUrl(shortcode);
    }

    save(url: string, shortcode?: string){
        if(!!shortcode){
            if(this.get(shortcode)){
                throw new ShortcodeExistsError('Shortcode already exists');
            }
        }else{
           shortcode = this.generateShortCode();
        }

        this.storage.addUrl(shortcode, url);
        this.storage.saveStats(shortcode, new ShortcodeStats());
        return shortcode;
    }

    updateUsage(shortcode: string){
        let stats = this.storage.getStats(shortcode);
        stats.update();
        this.storage.saveStats(shortcode, stats);
    }

    exists(shortcode: string): boolean {
        return !!this.get(shortcode);
    }

    getStats(shortcode: string): ShortcodeStats {
        return this.storage.getStats(shortcode);
    }

    private generateShortCode(): string{
        let shortcode;
        do{
            shortcode = this.shortcodeGenerator.generate();
        }while(this.exists(shortcode));

        return shortcode;
    }
}