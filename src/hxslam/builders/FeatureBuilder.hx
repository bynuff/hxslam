package hxslam.builders;

import hxslam.common.IContext;
import hxslam.features.base.IFeature;
import hxslam.builders.base.IFeatureBuilder;

class FeatureBuilder<T> implements IFeatureBuilder<T> {

    var _context:IContext<T>;
    var _features:Array<IFeature<T>>;

    public function new() {
        _features = [];
    }

    public function setContext(context:IContext<T>):IFeatureBuilder<T> {
        _context = context;
        return this;
    }

    public function setFeature(feature:IFeature<T>):IFeatureBuilder<T> {
        _features.push(feature);
        return this;
    }

    public function build() {
        for (feature in _features) {
            for (field in _context.getResults()) {
                feature.apply(field);
            }
            feature.storeResults();
        }
    }

}
