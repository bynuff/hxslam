package hxslam;

#if macro

import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;

using hxslam.transform.TransformContext.Factory;

class SlamMacro {

    public static function global() {
        Compiler.addGlobalMetadata(Constants.EMPTY, Constants.SLAM_GLOBAL_META);
    }

    public static function build():Array<Field> {
        var classType:ClassType = getClassType();
        var fields:Array<Field> = Context.getBuildFields();

        if (canBuildFields(classType)) {

            markAsProcessed(classType);

            return fields
                .createTransformContext()
                .transform()
                .getResults();
        }

        return fields;
    }

    static function canBuildFields(classType:ClassType):Bool {
        return classType != null
                && !classType.isInterface
                && !classType.isExtern
                && !classType.meta.has(Constants.SLAM_PROCESSED_META)
                #if slamManualMode && classType.meta.has(Constants.SLAM_META) #end;
    }

    static function markAsProcessed(classType:ClassType) {
        classType.meta.add(Constants.SLAM_PROCESSED_META, [], classType.pos);
    }

    static function getClassType():ClassType {
        return try {
            Context.getLocalClass().get();
        } catch(e:Dynamic) {
            null;
        }
    }

}

#end
