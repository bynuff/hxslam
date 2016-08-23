package hxslam.common;

import hxslam.common.IContext;

class Process<T> {

    public var processedItems(default, null):Array<T>;

    var _context:IContext<T>;
    var _isDone:Bool = false;

    public function new(context:IContext<T>) {
        _context = context;
        processedItems = [];
    }

    public function store(item:T) {
        processedItems.push(item);
    }

    public function done():Void {
        if (!_isDone) {
            _isDone = true;
            _context.endProcess(this);
        }
    }

}
