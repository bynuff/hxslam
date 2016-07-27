package hxslam.features.utils;

#if macro

import haxe.macro.Expr;

class FeatureUtil {

    public static function extractFieldExpr(field:Field):Expr {
        return switch (field.kind) {
            case FVar(_, fdExpr) | FProp(_, _, _, fdExpr):
                fdExpr;
            case FFun(f):
                f.expr;
        }
    }

}

#end
