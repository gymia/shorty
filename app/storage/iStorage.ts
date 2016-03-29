import {ShortcodeStats} from '../models/shortcodeStats';

export interface IStorage {
    getUrl(shortcode: string): string;
    addUrl(shortcode: string, url: string);
    getStats(shortcode: string): ShortcodeStats;
    saveStats(shortcode: string, stats: ShortcodeStats);
}