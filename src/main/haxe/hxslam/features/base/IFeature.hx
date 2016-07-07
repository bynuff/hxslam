package hxslam.features.base;

interface IFeature<T> {
    function apply(item:T):Void;
    function storeResults():Void;
}
