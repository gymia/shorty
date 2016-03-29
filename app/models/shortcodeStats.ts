export class ShortcodeStats {
    private _startDate: Date;
    private _lastSeenDate: Date;
    private _redirectCount: number;

    constructor(){
        this._startDate = new Date();
        this._redirectCount = 0;
    }

    get startDate(): Date {
        return this._startDate;
    }

    get lastSeenDate(): Date {
        return this._lastSeenDate;
    }

    get redirectCount(): Number{
        return this._redirectCount;
    }

    update(): ShortcodeStats{
        this._lastSeenDate = new Date();
        this._redirectCount++;

        return this;
    }
}