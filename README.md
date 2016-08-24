# hxslam

[![Lang](https://img.shields.io/badge/language-haxe-orange.svg)](http://haxe.org) [![Version](https://img.shields.io/badge/version-v0.3.0-green.svg)](https://github.com/bynuff/hxslam) [![Dependencies](https://img.shields.io/badge/dependencies-none-green.svg)](https://github.com/bynuff/hxslam/blob/master/haxelib.json) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

[![Build Status](https://api.travis-ci.org/bynuff/hxslam.svg?branch=master)](https://travis-ci.org/bynuff/hxslam) [![Build status](https://ci.appveyor.com/api/projects/status/yvlxcdfbd9rdhpdj/branch/master?svg=true)](https://ci.appveyor.com/project/bynuff/hxslam/branch/master)

*Short lambda cross platform library.*

### Install

 * Install with `haxelib install hxslam`.
 * Set in your `hxml` project file `-lib hxslam`.
 * Use short lambda sugar in your project!
 
###### *Manual mode:*

> *Library supported manual mode. For activating manual mode, use in your `hxml` project file `-D slamManualMode`. Then mark all classes where will be used short lambda by `@:slam` metadata.*

### *Features disabling:*

> *Control used features at conditional compilation. By default all features are available.*
> *For disabling specific feature use one of these conditional compilation flags:*

> * `-D slamNoTypedFeature`

> * `-D slamNoPropertyFeature`

> Note: *If all features will be disabled, stays available only simple short lambda with supporting optional and default value arguments.*

### Usage

* Function without arguments:

```haxe
function() return "Hello world!"; // in haxe
(_) => "Hello world"; // in hxslam
```

> Note: *Use underscore in parenthesis when function has no arguments.*

* Function with single argument:

```haxe
function(a) return a; // in haxe
(a) => a; // in hxslam
```

* Function with arguments:

```haxe
function(a, b, c) return a + b + c; // in haxe
([a, b, c]) => a + b + c; // in hxslam
```

> Note: *Use square brackets for arguments.*

* Multiline function:

```haxe
// in haxe
function(a = "Hello world!") {
    var result = "";
    var i = a.length;
    
    while (i > 0) {
        --i;
        result += a.charAt(i);
    }
    
    return result;
}
// in hxslam
(a = "Hello world!") => {
    var result = "";
    var i = a.length;
    
    while (i > 0) {
        --i;
        result += a.charAt(i);
    }
        
    result;
}
```

> Note: *Returned value should be at the last line in code block.*

### Typed arguments:

> Note: *Library also support typed arguments except for anonymous structures.*

* Simple type:

```haxe
function(a:String) return a; // in haxe
(a(String)) => a; // in hxslam

function(a:String, b:MyType) return b.someMethod(a); // in haxe
([a(String), b(MyType)]) => b.someMethod(a); // in hxslam
```

* Generics:

```haxe
function(a:Array<String>) return a[0] + a[1]; // in haxe
(a(Array(String))) => a[0] + a[1]; // in hxslam

function(a:MyGeneric<Int, String>) return a.toString(); // in haxe
(a(MyGeneric(Int, String))) => a.toString(); // in hxslam
```

* Function type:

```haxe
function(f:String -> Int -> Float) return f("Haxe", "3.3.0"); // in haxe
(f(String > Int > Float)) => f("Haxe", "3.3.0"); // in hxslam

function(f:Array<String> -> MyGeneric<Int, String>) return f("Haxe"); // in haxe
(f(Array(String) > MyGeneric(Int, String))) => f("Haxe"); // in hxslam

function(f:(Void -> String) -> String) return f(function() return "Haxe"); // in haxe
(f((Void > String) > String)) => f((_) => "Haxe"); // in hxslam
```

* Default values for function arguments:

```haxe
function(a:String = "empty") return a; // in haxe
(a(String) = "empty") => a; // in hxslam

function(a = 1024) return a; // in haxe
(a = 1024) => a; // in hxslam

function(a:String, b:Int = 1024) return a + b; // in haxe
([a(String), b(Int) = 1024]) => a + b; // in hxslam
```

* Optional arguments in functions and function types:

```haxe
function(?a:String) return a; // in haxe
(-a(String)) => a; // in hxslam

function(a:String = "Haxe", ?b:Int) return a + b; // in haxe
([a(String) = "Haxe", -b(Int)]) => a + b; // in hxslam

function(f:String -> ?Int -> String) return f("Haxe"); // in haxe
(f(String > -Int -> String)) => f("Haxe"); // in hxslam
```

### Properties:

> *Short lambdas also available to use in properties declaration with overridden support.*

> Notes:

> * *All short lambdas worked correctly inside short property methods.*
> * *`value` is reserved argument name for setters.*
> * *Use underscore for short declaration property(get/set) which used only one local variable.*
> * *Returned value in getters should be at the last line in code block.*

```haxe
class TestA {

    // in haxe
    // public static var REVERSE_TAG(get, set):String;
    // static function get_REVERSE_TAG():String {
    //     var result = "";
    //     var i = _tag.length;
    //     do {
    //         --i;
    //         result += _tag.charAt(i);
    //     } while (i > 0);
    //     return result;
    // }
    // static function set_REVERSE_TAG(value:String) {
    //     return _tag;
    // }
    // in hxslam
    public static var REVERSE_TAG:String = {
        get => {
            var result = "";
            var i = _tag.length;
            do {
                --i;
                result += _tag.charAt(i);
            } while (i > 0);
            result;
        }
        set => _tag = value;
    }
    
    static var _tag:String;

    // in haxe
    // public var className(get, never):String;
    // function get_className():String { return "TestA"; }
    // in hxslam
    public var className:String = {
        get => "TestA";
    };

    // in haxe
    // public var name(get, set):String;
    // function get_name():String { return _name; }
    // function set_name(value:String) { return _name = value; }
    // in hxslam
    public var name:String = { _ => _name; };
    
    var _name:String;
    
    public function new(name:String) {
        _name = name;
    }
    
}
```

* Override properties:

> Note: *You can call super method in getter/setter like in original haxe methods.*

```haxe
class TestB extends TestA {

    // in haxe
    // override function get_className():String { return "TestB"; }
    // in hxslam
    override public var className:String = {
        get => "TestB";
    };

    // in haxe
    // override function get_name():String { return _id; }
    // override function set_name(value:String) { return _id = "id_" + super.set_name(value); }
    // in hxslam
    override public var name:String = {
        get => _id;
        set => _id = "id_" + super.set_name(value);
    };
    
    var _id:String;
    
    public function new(name:String) {
        super(name);
    }
    
}
```
