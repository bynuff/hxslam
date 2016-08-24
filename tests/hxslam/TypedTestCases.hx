package hxslam;

import utest.Assert;

@:keep @:slam
class TypedTestCases {

    public function new() {}

    public function testShortLambdaWithTypedArgs() {
        var sl1 = (arg(Dynamic)) => arg;
        var sl2 = (arg(String)) => arg + "qwerty";
        var sl3 = ([arg1(String), arg2(Int)]) => {
            for (i in 0...arg2) {
                arg1 += i;
            }
            arg1;
        };
        var sl4 = ([arg1(Int), arg2(String)]) => sl1(arg1) + sl2(arg2);

        Assert.notNull(sl1);
        Assert.equals(7, sl1(7));
        Assert.equals("qwerty", sl1("qwerty"));

        Assert.notNull(sl2);
        Assert.equals("7qwerty", sl2("7"));

        Assert.notNull(sl3);
        Assert.equals("numbers:01234", sl3("numbers:", 5));

        Assert.notNull(sl4);
        Assert.equals("7qwerty", sl4(7, ""));
    }

    public function testShortLambdaWithOptionalTypedArgs() {
        var sl1 = (-arg(Dynamic)) => arg;
        var sl2 = (arg(String) = "") => arg + "qwerty";
        var sl3 = ([-arg1(String), arg2(Int) = 7]) => {
            for (i in 0...arg2) {
                arg1 += i;
            }
            arg1;
        };
        var sl4 = ([-arg1(Int), arg2(String) = "Y"]) => sl1(arg1) + sl2(arg2);

        Assert.notNull(sl1);
        Assert.isNull(sl1());
        Assert.equals(7, sl1(7));
        Assert.equals("qwerty", sl1("qwerty"));

        Assert.notNull(sl2);
        Assert.equals("qwerty", sl2());
        Assert.equals("7qwerty", sl2("7"));

        Assert.notNull(sl3);
        Assert.raises((_) => sl3());
        Assert.raises((_) => sl3(10));
        Assert.equals("numbers:01234", sl3("numbers:", 5));

        Assert.notNull(sl4);
        Assert.equals("11Yqwerty", sl4(11));
        Assert.equals("nullYqwerty", sl4());
        Assert.equals("7qwerty", sl4(7, ""));
        Assert.equals("nullEqwerty", sl4("E"));
    }

    public function testShortLambdaWithGenericTypedArgs() {
        var sl1 = (arg(Array(String))) => arg.length;
        var sl2 = ([arg1(Int) = 0, arg2(Array(Int))]) => arg2[arg1];
        var sl3 = ([arg1(String), arg2(Array(String))]) => {
            var i = 0;
            var result = -1;

            while (i < arg2.length) {
                if (arg1 == arg2[i]) {
                    result = i;
                    break;
                }
                i++;
            }
            result;
        };
        var sl4 = ([arg1(Int), arg2(Array(MyGeneric(Int, String)))]) => Std.string(arg2[arg1]);

        Assert.notNull(sl1);
        Assert.equals(0, sl1([]));
        Assert.equals(3, sl1(["a", "b", "c"]));

        Assert.notNull(sl2);
        Assert.raises((_) => sl2(7, null));
        Assert.equals(7, sl2(2, [0, 17, 7, 14]));
        Assert.equals(0, sl2([0, 17, 7, 14]));

        Assert.notNull(sl3);
        Assert.equals(-1, sl3("Z", ["A", "B", "C", "D"]));
        Assert.equals(1, sl3("B", ["A", "B", "C", "D"]));
        Assert.equals(1, sl3("B", ["A", "B", "B", "D"]));

        Assert.notNull(sl4);
        Assert.equals(
            "7:minutes",
            sl4(
                3,
                [
                    new MyGeneric<Int, String>(0, "minutes"),
                    new MyGeneric<Int, String>(6, "hours"),
                    new MyGeneric<Int, String>(3, "month"),
                    new MyGeneric<Int, String>(7, "minutes"),
                    new MyGeneric<Int, String>(10, "seconds")
                ]
            )
        );
        Assert.notEquals(
            "7:minutes",
            sl4(
                4,
                [
                    new MyGeneric<Int, String>(0, "minutes"),
                    new MyGeneric<Int, String>(6, "hours"),
                    new MyGeneric<Int, String>(3, "month"),
                    new MyGeneric<Int, String>(7, "minutes"),
                    new MyGeneric<Int, String>(10, "seconds")
                ]
            )
        );
    }

    public function testShortLambdaWithOptionalGenericTypedArgs() {
        var sl1 = (-arg(Array(String))) => arg.length;
        var sl2 = ([arg1(Int) = 0, -arg2(Array(Int))]) => arg2[arg1];
        var sl3 = ([arg1(String), -arg2(Array(String))]) => {
            var i = 0;
            var result = -1;

            if (arg2 == null) {
                arg2 = ["none"];
            }
            while (i < arg2.length) {
                if (arg1 == arg2[i]) {
                    result = i;
                    break;
                }
                i++;
            }
            result;
        };
        var sl4 = ([arg1(Int), -arg2(Array(MyGeneric(Int, String)))]) => Std.string(arg2[arg1]);

        Assert.notNull(sl1);
        Assert.raises((_) => sl1());
        Assert.equals(3, sl1(["a", "b", "c"]));

        Assert.notNull(sl2);
        Assert.raises((_) => sl2(7));
        Assert.equals(7, sl2(2, [0, 17, 7, 14]));

        Assert.notNull(sl3);
        Assert.equals(0, sl3("none"));
        Assert.equals(-1, sl3("Z"));
        Assert.equals(-1, sl3("Z", ["A", "B", "C", "D"]));
        Assert.equals(1, sl3("B", ["A", "B", "C", "D"]));
        Assert.equals(1, sl3("B", ["A", "B", "B", "D"]));

        Assert.notNull(sl4);
        Assert.raises((_) => sl4(4));
        Assert.equals(
            "7:minutes",
            sl4(
                3,
                [
                    new MyGeneric<Int, String>(0, "minutes"),
                    new MyGeneric<Int, String>(6, "hours"),
                    new MyGeneric<Int, String>(3, "month"),
                    new MyGeneric<Int, String>(7, "minutes"),
                    new MyGeneric<Int, String>(10, "seconds")
                ]
            )
        );
    }

    public function testShortLambdaWithFunctionTypedArgs() {
        var sl1 = ([arg1(Int), arg2(String), arg3(Int > String > String)]) => arg3(arg1, arg2);
        var sl2 = (arg(Int > String > (Int > String > String) > String)) => arg;
        var sl3 = ([arg1(Int), arg2(String), arg3(Int > String > MyGeneric(Int, String))]) => arg3(arg1, arg2);

        Assert.notNull(sl1);
        Assert.equals("7qwerty", sl1(7, "qwerty", ([arg1(Int), arg2(String)]) => arg1 + arg2));
        Assert.equals("t", sl1(4, "qwerty", ([arg1(Int), arg2(String)]) => arg2.charAt(arg1)));

        Assert.notNull(sl2);
        Assert.isNull(sl2(null));
        Assert.equals("7qwerty", sl2(sl1)(7, "qwerty", ([arg1(Int), arg2(String)]) => arg1 + arg2));
        Assert.equals("t", sl2(sl1)(4, "qwerty", ([arg1(Int), arg2(String)]) => arg2.charAt(arg1)));

        Assert.notNull(sl3);
        Assert.is(sl3(37, "minutes", ([arg1(Int), arg2(String)]) => new MyGeneric(arg1, arg2)), MyGeneric);
        Assert.equals('37:minutes', Std.string(sl3(37, "minutes", ([arg1(Int), arg2(String)]) => new MyGeneric(arg1, arg2))));
    }

    public function testShortLambdaWithOptionalFunctionTypedArgs() {
        var sl1 = ([-arg1(Int), -arg2(String), arg3(-Int > -String > String)]) => arg3(arg1, arg2);
        var sl2 = (arg(-Int > -String > (-Int > -String > String) > String)) => arg;
        var sl3 = ([-arg1(Int), -arg2(String), arg3(-Int > -String > MyGeneric(Int, String))]) => arg3(arg1, arg2);

        Assert.notNull(sl1);
        Assert.equals("70qwe", sl1(([arg1(Int) = 70, arg2(String) = "qwe"]) => arg1 + arg2));
        Assert.equals("e", sl1(2, ([-arg1(Int), arg2(String) = "qwe"]) => arg2.charAt(arg1)));

        Assert.notNull(sl2);
        Assert.isNull(sl2(null));
        Assert.equals("55qwerty", sl2(sl1)(([arg1(Int) = 55, arg2(String) = "qwerty"]) => arg1 + arg2));
        Assert.equals("55qwe", sl2(sl1)("qwe", ([arg1(Int) = 55, arg2(String) = "qwerty"]) => arg1 + arg2));
        Assert.equals("7qwerty", sl2(sl1)(7, ([arg1(Int) = 55, arg2(String) = "qwerty"]) => arg1 + arg2));

        Assert.notNull(sl3);
        Assert.raises((_) => sl3(37, "minutes", null));
        Assert.equals("0:seconds", Std.string(sl3(([arg1(Int) = 0, arg2(String) = "seconds"]) => new MyGeneric(arg1, arg2))));
        Assert.equals("30:seconds", Std.string(sl3(30, ([arg1(Int) = 0, arg2(String) = "seconds"]) => new MyGeneric(arg1, arg2))));
        Assert.equals("0:minutes", Std.string(sl3("minutes", ([arg1(Int) = 0, arg2(String) = "seconds"]) => new MyGeneric(arg1, arg2))));
        Assert.is(sl3(37, "minutes", ([-arg1(Int), -arg2(String)]) => new MyGeneric(arg1, arg2)), MyGeneric);
        Assert.equals('37:minutes', Std.string(sl3(37, "minutes", ([-arg1(Int), -arg2(String)]) => new MyGeneric(arg1, arg2))));
    }

}

class MyGeneric<T, V> {

    var _arg1:T;
    var _arg2:V;

    public function new(arg1:T, arg2:V) {
        _arg1 = arg1;
        _arg2 = arg2;
    }

    public function toString():String {
        return '$_arg1:$_arg2';
    }

}
