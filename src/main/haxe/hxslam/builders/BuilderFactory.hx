package hxslam.builders;

#if macro

import haxe.macro.Expr.Field;

import hxslam.common.IContext;
import hxslam.features.TypedFeature;
import hxslam.features.DefaultFeature;
import hxslam.features.PropertyFeature;
import hxslam.builders.base.IFeatureBuilder;

typedef FeatureBuilderFactory<T> = IContext<T> -> IFeatureBuilder<T>;

class BuilderFactory {

    public static function fieldBuilderFactory(context:IContext<Field>):IFeatureBuilder<Field> {
        return new FeatureBuilder<Field>()
            #if slamNoTypedFeature
            .setFeature(new DefaultFeature(context.createProcess()))
            #else
            .setFeature(new TypedFeature(context.createProcess()))
            #end
            #if !slamNoPropertyFeature
            .setFeature(new PropertyFeature(context.createProcess()))
            #end
            .setContext(context);
    }

}

#end
