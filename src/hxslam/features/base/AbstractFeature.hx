package hxslam.features.base;

import hxslam.common.Process;

class AbstractFeature<T> implements IFeature<T> {

    var _process:Process<T>;

    public function new(process:Process<T>) {
        _process = process;
    }

    public function apply(item:T) {
        throw "AbstractFeature:apply abstract method should be overriden.";
    }

    public function storeResults() {
        _process.done();
    }

}
