package hxslam.features;

#if macro

import haxe.macro.Expr;
import haxe.macro.Context;

import hxslam.common.Process;

class TypedFeature extends DefaultFeature {

    public function new(process:Process<Field>) {
        super(process);
    }

    override function parseFuncArgs(fExpr:Expr, ?isOpt:Bool):Array<FunctionArg> {
        return try {
            switch (fExpr.expr) {
                case EBinop(OpAssign, e1 = {expr: ECall(e = {expr: EConst(CIdent(s)), pos: _}, params = [e3]), pos: _}, e2):
                    [createFuncArg(s, e3, e2, isOpt)];
                case EBinop(OpAssign, e1 = {expr: EUnop(OpNeg, false, {expr: ECall(e = {expr: EConst(CIdent(s)), pos: _}, params = [e3]), pos: _}), pos: _}, e2):
                    [createFuncArg(s, e3, e2, true)];
                case ECall(e = {expr: EConst(CIdent(s)), pos: _}, params = [e1]):
                    [createFuncArg(s, e1, isOpt)];
                case _:
                    super.parseFuncArgs(fExpr, isOpt);
            }
        } catch (e:Dynamic) {
            Context.error("Expression can't be null!", Context.currentPos());
        }
    }

    override function getComplexType(tExpr:Expr, ?tParam:Array<TypeParam>):ComplexType {
        return try {
            switch (tExpr.expr) {
                case EConst(CIdent(s)):
                    TPath({pack: [], name: s, params: tParam != null ? tParam : []});
                case EUnop(OpNeg, false, e):
                    TOptional(getComplexType(e));
                case ECall(e, params):
                    getComplexType(e, [ for (p in params) TPType(getComplexType(p)) ]);
                case EBinop(OpGt, e1, e2):
                    var notSubFunc = function (e:Expr):Bool {
                        return switch (e.expr) {
                            case EParenthesis(_):
                                false;
                            case _:
                                true;
                        }
                    };

                    var tRet = null;
                    var tArgs = null;

                    var ct1 = getComplexType(e1);
                    var ct2 = getComplexType(e2);

                    switch (ct1) {
                        case TFunction(args, ret) if (notSubFunc(e1)):
                            args.push(ret);
                            tArgs = args;
                        case _:
                            tArgs = [ct1];
                    }

                    switch (ct2) {
                        case TFunction(args, ret) if (notSubFunc(e2)):
                            tArgs = tArgs.concat(args);
                            tRet = ret;
                        case _:
                            tRet = ct2;
                    }

                    TFunction(tArgs, tRet);
                case EParenthesis(e):
                    getComplexType(e);
                case _:
                    Context.error("Type declaration syntax exception!", tExpr.pos);
            }
        } catch (e:Dynamic) {
            null;
        }
    }

}

#end
