package hxslam.builders;

#if macro

import haxe.macro.Expr.Field;

import hxslam.common.IContext;
import hxslam.features.TypedFeature;
import hxslam.features.PropertyFeature;
import hxslam.builders.base.IFeatureBuilder;

typedef FeatureBuilderFactory<T> = IContext<T> -> IFeatureBuilder<T>;

class BuilderFactory {

    public static function defaultFieldBuilderFactory(context:IContext<Field>):IFeatureBuilder<Field> {
        return new FeatureBuilder<Field>()
            .setContext(context)
            .setFeature(new TypedFeature(context.createProcess()))
            .setFeature(new PropertyFeature(context.createProcess()));
    }

}

#end
