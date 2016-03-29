import {IStorage} from "./iStorage";
import {ShortcodeStats} from "../models/shortcodeStats";

export class InMemoryStorage implements IStorage{
    private shortcodes: {[shortcode: string]: string};
    private stats: {[shortcode: string]: ShortcodeStats};

    constructor(){
        this.shortcodes = {};
        this.stats = {};
    }

    getUrl(shortcode: string): string {
        return this.shortcodes[shortcode];
    }

    addUrl(shortcode: string, url: string) {
        this.shortcodes[shortcode] = url;
        this.stats[shortcode] = new ShortcodeStats();
    }

    getStats(shortcode: string): ShortcodeStats {
        return this.stats[shortcode];
    }

    saveStats(shortcode: string, stats: ShortcodeStats) {
        this.stats[shortcode] = stats;
    }
}