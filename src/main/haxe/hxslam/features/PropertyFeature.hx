package hxslam.features;

#if macro

import haxe.macro.Expr;
import haxe.macro.Context;

import hxslam.common.Process;
import hxslam.features.base.AbstractFeature;

class PropertyFeature extends AbstractFeature<Field> {

    inline public static var GET:String = "get";
    inline public static var SET:String = "set";
    inline public static var NEVER:String = "never";
    inline public static var UNIVERSAL:String = "_";

    public function new(process:Process<Field>) {
        super(process);
    }

    override public function apply(field:Field) {
        trace(field);

        if (tryGetPropertyData(field, function (value) generatePropertyFields(field, value))) {
            return;
        }

        _process.store(field);
    }

    function tryGetPropertyData(field:Field, out:EPropertyData -> Void):Bool {
        return switch (field.kind) {
            case FVar(t, e = {expr: EBlock(exprs), pos: _}) if (exprs.length != 0 && exprs.length <= 2):
                tryGetPropertyExprs(
                    exprs,
                    function (value:EPropertyData) {
                        value.type = t;
                        value.isStatic = field.access.indexOf(AStatic) != -1;
                        value.isOverride = field.access.indexOf(AOverride) != -1;
                        out(value);
                    }
                );
            case _:
                false;
        }
    }

    function tryGetPropertyExprs(fdExprs:Array<Expr>, out:EPropertyData -> Void):Bool {
        var data:EPropertyData = new EPropertyData();
        for (expr in fdExprs) {
            switch (expr.expr) {
                case EBinop(OpArrow, e1 = {expr: EConst(CIdent(GET)), pos: _}, e2):
                    if (data.getExpr != null) Context.error("Property get expression already set.", expr.pos);
                    data.getExpr = e2;
                case EBinop(OpArrow, e1 = {expr: EConst(CIdent(SET)), pos: _}, e2):
                    if (data.setExpr != null) Context.error("Property set expression already set.", expr.pos);
                    data.setExpr = e2;
                case EBinop(OpArrow, e1 = {expr: EConst(CIdent(UNIVERSAL)), pos: _}, e2):
                    if (data.getExpr != null || data.setExpr != null)
                        Context.error("Property get/set expression already set.", expr.pos);
                    data.getExpr = e2;
                    data.setExpr = macro $e2 = value;
                case _:
                    return false;
            }
        }
        if (data.getExpr != null || data.setExpr != null) {
            out(data);
            return true;
        }
        return false;
    }

    function generatePropertyFields(field:Field, data:EPropertyData) {
        var access = [];
        if (data.isStatic) access.push(AStatic);
        if (data.isOverride) access.push(AOverride);

        if (data.isOverride) {
            if (data.isStatic) Context.error("Static property can not be overriden!", field.pos);
            _process.store(field);
        } else {
            _process.store(generateProperty(field, data));
        }

        if (data.getExpr != null) {
            _process.store(
                generateGetFunction(field, data, access)
            );
        }

        if (data.setExpr != null) {
            _process.store(
                generateSetFunction(field, data, access)
            );
        }

    }

    function generateProperty(field:Field, data:EPropertyData):Field {
        return {
            name: field.name,
            doc: field.doc,
            access: field.access,
            kind: FProp(
                data.getExpr != null ? GET : NEVER,
                data.setExpr != null ? SET : NEVER,
                data.type, null
            ),
            pos: field.pos,
            meta: field.meta
        };
    }

    function generateGetFunction(field:Field, data:EPropertyData, access:Array<Access>):Field {
        return {
            name: GET + "_" + field.name,
            access: access,
            kind: FFun({
                args: [],
                ret: data.type,
                expr: macro return ${data.getExpr},
                params: []
            }),
            pos: data.getExpr.pos
        };
    }

    function generateSetFunction(field:Field, data:EPropertyData, access:Array<Access>):Field {
        return {
            name: SET + "_" + field.name,
            access: access,
            kind: FFun({
                args: [{
                    name: "value",
                    type: data.type
                }],
                ret: null,
                expr: macro return ${data.setExpr},
                params: []
            }),
            pos: data.setExpr.pos
        };
    }

}

@:allow(hxslam.features.PropertyFeature)
class EPropertyData {

    var isStatic:Bool;
    var isOverride:Bool;
    var getExpr:Null<Expr>;
    var setExpr:Null<Expr>;
    var type:Null<ComplexType>;

    function new() {}

}

#end
