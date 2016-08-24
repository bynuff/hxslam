package hxslam;

import utest.Assert;

@:keep @:slam
class CommonTestCases {

    public function new() {}

    public function testShortLambdaWithoutArgs() {
        var sl1 = (_) => 7;
        var sl2 = (_) => "qwerty";
        var sl3 = (_) => {
            var result = 0;
            for (i in 0...10) {
                result += i;
            }
            result;
        };
        var sl4 = (_) => ((_) => "777");
        var sl5 = (_) => sl1() + sl2();

        Assert.notNull(sl1);
        Assert.equals(7, sl1());

        Assert.notNull(sl2);
        Assert.equals("qwerty", sl2());

        Assert.notNull(sl3);
        Assert.equals(45, sl3());

        Assert.notNull(sl4);
        Assert.equals("777", sl4()());

        Assert.notNull(sl5);
        Assert.equals("7qwerty", sl5());
    }

    public function testShortLambdaWithArgs() {
        var sl1 = (arg) => arg;
        var sl2 = (arg) => arg + "qwerty";
        var sl3 = ([arg1, arg2]) => {
            for (i in 0...arg2) {
                arg1 += i;
            }
            arg1;
        };
        var sl4 = (arg) => arg("777");
        var sl5 = ([arg1, arg2]) => Std.string(sl1(arg1)) + sl2(arg2);

        Assert.notNull(sl1);
        Assert.equals(7, sl1(7));

        Assert.notNull(sl2);
        Assert.equals("7qwerty", sl2("7"));

        Assert.notNull(sl3);
        Assert.equals(13, sl3(3, 5));

        Assert.notNull(sl4);
        Assert.equals("777", sl4((arg) => arg));

        Assert.notNull(sl5);
        Assert.equals("7qwerty", sl5(7, ""));
    }

    public function testShortLambdaWithOptionalArgs() {
        var sl1 = (-arg) => arg;
        var sl2 = (arg = "Z") => arg + "qwerty";
        var sl3 = ([arg1, arg2 = 7]) => {
            for (i in 0...arg2) {
                arg1 += i;
            }
            arg1;
        };
        var sl4 = (-arg) => (arg != null ? arg("777") : "empty");
        var sl5 = ([-arg1, -arg2]) => Std.string(sl1(arg1)) + sl2(arg2);

        Assert.notNull(sl1);
        Assert.isNull(sl1());
        Assert.equals(7, sl1(7));

        Assert.notNull(sl2);
        Assert.equals("7qwerty", sl2("7"));
        Assert.equals("Zqwerty", sl2());

        Assert.notNull(sl3);
        Assert.equals(13, sl3(3, 5));
        Assert.equals(24, sl3(3));

        Assert.notNull(sl4);
        Assert.equals("777", sl4((arg) => arg));
        Assert.equals("empty", sl4());

        Assert.notNull(sl5);
        Assert.equals("7qwerty", sl5(7, ""));
        Assert.equals("5Zqwerty", sl5(5));
        Assert.equals("nullRqwerty", sl5("R"));
        Assert.equals("nullZqwerty", sl5());
    }

}
