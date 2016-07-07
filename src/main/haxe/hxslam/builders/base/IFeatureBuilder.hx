package hxslam.builders.base;

import hxslam.common.IContext;
import hxslam.features.base.IFeature;

interface IFeatureBuilder<T> {
    function setContext(context:IContext<T>):IFeatureBuilder<T>;
    function setFeature(feature:IFeature<T>):IFeatureBuilder<T>;
    function build():Void;
}
