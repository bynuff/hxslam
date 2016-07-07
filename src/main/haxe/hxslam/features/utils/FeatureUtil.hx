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

    public static function createFuctionExpr(
        fArgs:Array<FunctionArg>, fName:String = null,
        fRet:Null<ComplexType>, fExpr:Null<Expr>,
        fParams:Array<TypeParamDecl> = null, fPos:Position
    ):Expr {
        return {
            expr: EFunction(
                fName,
                {
                    args: fArgs,
                    ret: fRet,
                    expr: fExpr,
                    params: fParams
                }
            ),
            pos: fPos
        };
    }


}

#end
