package hxslam.features;

#if macro

import haxe.macro.Expr.Field;

import hxslam.common.Process;
import hxslam.features.base.AbstractFeature;

class PropertyFeature extends AbstractFeature<Field> {

    public function new(process:Process<Field>) {
        super(process);
    }

    override public function apply(item:Field) {
        _process.store(item); // stub
    }

}

#end
