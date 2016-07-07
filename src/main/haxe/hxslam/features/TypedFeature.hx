package hxslam.features;

#if macro

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ExprTools;

import hxslam.common.Process;
import hxslam.features.utils.FeatureUtil;
import hxslam.features.base.AbstractFeature;

using hxslam.features.utils.FeatureUtil;

class TypedFeature extends AbstractFeature<Field> {

    public function new(process:Process<Field>) {
        super(process);
    }

    override public function apply(field:Field) {
        rebuildField(
            field,
            analyzeExpr(
                field.extractFieldExpr()
            )
        );
    }

    function rebuildField(field:Field, fdExpr:Expr) {
        field.kind = switch (field.kind) {
            case FVar(t, e):
                FVar(t, fdExpr);
            case FFun(f):
                FFun({args: f.args, ret: f.ret, expr: fdExpr, params: f.params});
            case FProp(g, s, t, e):
                FProp(g, s, t, fdExpr);
        }
        _process.store(field);
    }

    function analyzeExpr(fdExpr:Expr):Expr {
        return try {
            switch (fdExpr.expr) {
                case EBinop(op = OpArrow, e1 = {expr: EParenthesis(e), pos: _}, e2):
                    expandExpr(
                        ExprTools.map(e, analyzeExpr),
                        ExprTools.map(e2, analyzeExpr)
                    );
                case _:
                    ExprTools.map(fdExpr, analyzeExpr);
            }
        } catch(e:Dynamic) {
            null;
        }
    }

    function expandExpr(lExpr:Expr, rExpr:Expr):Expr {
        return parseFuncArgs(lExpr).createFuctionExpr(
            null, null,
            macro return $rExpr,
            lExpr.pos
        );
    }

    function parseFuncArgs(fExpr:Expr, ?isOpt:Bool):Array<FunctionArg> {
        return try {
            switch (fExpr.expr) {
                case EConst(CIdent("_")):
                    [];
                case EConst(CIdent(s)):
                    [createFuncArg(s, isOpt)];
                case EArrayDecl(values):
                    [ for (v in values) parseFuncArgs(v)[0] ];
                case EBinop(OpAssign, e1 = {expr: EConst(CIdent(s)), pos: _}, e2):
                    [createFuncArg(s, null, e2, isOpt)];
                case EBinop(OpAssign, e1 = {expr: ECall(e = {expr: EConst(CIdent(s)), pos: _}, params = [e3]), pos: _}, e2):
                    [createFuncArg(s, e3, e2, isOpt)];
                case EBinop(OpAssign, e1 = {expr: EUnop(OpNeg, false, {expr: EConst(CIdent(s)), pos: _}), pos: _}, e2):
                    [createFuncArg(s, null, e2, true)];
                case EBinop(OpAssign, e1 = {expr: EUnop(OpNeg, false, {expr: ECall(e = {expr: EConst(CIdent(s)), pos: _}, params = [e3]), pos: _}), pos: _}, e2):
                    [createFuncArg(s, e3, e2, true)];
                case EUnop(OpNeg, false, e):
                    parseFuncArgs(e, true);
                case ECall(e = {expr: EConst(CIdent(s)), pos: _}, params = [e1]):
                    [createFuncArg(s, e1, isOpt)];
                case _:
                    trace(fExpr);
                    Context.error("Argument syntax exception!", fExpr.pos);
            }
        } catch (e:Dynamic) {
            Context.error("Expression can't be null!", Context.currentPos());
        }
    }

    function createFuncArg(argName:String, ?tExpr:Expr, ?vExpr:Expr, ?isOpt:Bool):FunctionArg {
        return {
            name: argName,
            opt: isOpt || vExpr != null,
            type: getComplexType(tExpr),
            value: vExpr
        }
    }

    function getComplexType(tExpr:Expr, ?tParam:Array<TypeParam>):ComplexType {
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
