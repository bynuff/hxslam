package hxslam.transform;

#if macro

import haxe.macro.Expr.Field;

import hxslam.common.Process;
import hxslam.common.IContext;
import hxslam.builders.BuilderFactory;

typedef Factory = hxslam.transform.TransformContext;

class TransformContext implements IContext<Field> {

    var _processedFields:Array<Field>;
    var _builderFactory:FeatureBuilderFactory<Field>;

    public function new(fields:Array<Field>) {
        _processedFields = fields;
        _builderFactory = BuilderFactory.defaultFieldBuilderFactory;
    }

    public static function createTransformContext(fields:Array<Field>):TransformContext {
        return new TransformContext(fields);
    }

    public function setBuilderFactory(builderFactory:FeatureBuilderFactory<Field>):TransformContext {
        _builderFactory = builderFactory;
        return this;
    }

    public function transform():TransformContext {
        _builderFactory(this).build();
        return this;
    }

    public function getResults():Array<Field> {
        return _processedFields;
    }

    public function createProcess():Process<Field> {
        return new Process<Field>(this);
    }

    public function endProcess(process:Process<Field>) {
        _processedFields = process.processedItems;
    }

}

#end
