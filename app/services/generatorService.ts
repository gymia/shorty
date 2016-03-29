export class ShortcodeGenerator {
    private length: number;
    private chars: string;

    constructor() {
        this.length = 6;
        this.chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_';
    }

    public generate(): string {
        var result = '';
        for (var i = this.length; i > 0; --i) result += this.chars[Math.floor(Math.random() * this.chars.length)];
        return result;
    }
}