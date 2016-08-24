package hxslam;

import utest.Assert;

@:keep
class PropertyTestCases {

    public function new() {}

    public function testPropertyShortLambda() {
        var ptca = new PropertyTestClassA(null);
        var ptcb = new PropertyTestClassB(null);

        Assert.equals("PropertyTestClassA", PropertyTestClassA.PROP0);
        Assert.equals("PropertyTestClassB", PropertyTestClassB.PROP0);

        Assert.isNull(ptca.prop1);
        Assert.isFalse(ptca.prop2);
        Assert.notNull(ptca.prop3);
        Assert.equals("PropertyTestClassA:null", ptca.prop3());
        Assert.equals("PropertyTestClassA :: null", ptca.prop4);

        ptca.prop1 = "testA";
        ptca.prop4 = "__name__";

        Assert.notNull(ptca.prop1);
        Assert.isTrue(ptca.prop2);
        Assert.equals("PropertyTestClassA:testA", ptca.prop3());
        Assert.equals("PropertyTestClassA :: __name__", ptca.prop4);

        Assert.notNull(ptcb.prop1);
        Assert.equals("null B", ptcb.prop1);
        Assert.isFalse(ptcb.prop2);
        Assert.equals("PropertyTestClassA:null", ptcb.prop3());
        Assert.isNull(ptcb.prop4);

        ptcb.prop4 = "__name__";

        Assert.isFalse(ptcb.prop2);

        ptcb.prop1 = "testB";

        Assert.equals("testB B", ptcb.prop1);
        Assert.isTrue(ptcb.prop2);
        Assert.notNull(ptcb.prop4);
        Assert.equals("PropertyTestClassB__name__", ptcb.prop4);
    }

}

@:slam
class PropertyTestClassA {

    public static var PROP0:String = {
        get => "PropertyTestClassA";
    };

    public var prop1:String = { _ => _id; };
    public var prop2:Bool = {
        get => _id != null;
    };
    public var prop3:Void -> String = {
        get => (_) => '$PROP0:$_id';
    };
    public var prop4:String = {
        get => '$PROP0 :: $_name';
        set => _name = value;
    };

    var _id:String;
    var _name:String;

    public function new(id:String) {
        _id = id;
    }

}

@:slam
class PropertyTestClassB extends PropertyTestClassA {

    public static var PROP0:String = {
        get => "PropertyTestClassB";
    };

    override public var prop1:String = { get => '$_id B'; };
    override public var prop2:Bool = {
        get => super.get_prop2() && _name != null;
    };
    override public var prop4:String = {
        get => _name;
        set => _name = PROP0 + value;
    };

    public function new(id:String) {
        super(id);
    }

}
