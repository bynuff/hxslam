# hxslam

[![Lang](https://img.shields.io/badge/language-haxe-orange.svg)](http://haxe.org) [![Version](https://img.shields.io/badge/version-v0.1.1-green.svg)](https://github.com/bynuff/hxslam) [![Dependencies](https://img.shields.io/badge/dependencies-none-green.svg)](https://github.com/bynuff/hxslam/blob/master/haxelib.json) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

*Short lambda cross platform library for Haxe.*

### Install

 * Install with `haxelib install hxslam`.
 * Set in your `hxml` project file `-lib hxslam`.
 * Use short lambda sugar in your project!
 
###### *Manual mode:*

> *Library supported manual mode. For activating manual mode, use in your `hxml` project file `-D slamManualMode`. Then mark all classes where will be used short lambda by `@:slam` metadata.*

### Usage

* Function without arguments:

```haxe
function() return "Hello world!"; // haxe
(_) => "Hello world"; // hxslam
```

> *Use underscore in parenthesis when function has no arguments.*

* Function with single argument:

```haxe
function(a) return a; // haxe
(a) => a; // hxslam
```

* Function with arguments:

```haxe
function(a, b, c) return a + b + c; // haxe
([a, b, c]) => a + b + c; // hxslam
```

> *Use square brackets for arguments.*

### Typed arguments:

> *Library also support typed arguments except for anonymous structures.*

* Simple type:

```haxe
function(a:String) return a; // haxe
(a(String)) => a; // hxslam

function(a:String, b:MyType) return b.someMethod(a); // haxe
([a(String), b(MyType)]) => b.someMethod(a); // hxslam 
```

* Generics:

```haxe
function(a:Array<String>) return a[0] + a[1]; // haxe
(a(Array(String))) => a[0] + a[1]; // hxslam

function(a:MyGeneric<Int, String>) return a.toString(); // haxe
(a(MyGeneric(Int, String))) => a.toString(); // hxslam
```

* Function type:

```haxe
function(f:String -> Int -> Float) return f("Haxe", "3.3.0"); // haxe
(f(String > Int > Float)) => f("Haxe", "3.3.0"); // hxslam

function(f:Array<String> -> MyGeneric<Int, String>) return f("Haxe"); // haxe
(f(Array(String) > MyGeneric(Int, String))) => f("Haxe"); // hxslam

function(f:(Void -> String) -> String) return f(function() return "Haxe"); // haxe
(f((Void > String) > String)) => f((_) => "Haxe"); // hxslam
```

* Default values for function arguments:

```haxe
function(a:String = "empty") return a; // haxe
(a(String) = "empty") => a; // hxslam

function(a = 1024) return a; // haxe
(a = 1024) => a; // hxslam

function(a:String, b:Int = 1024) return a + b; // haxe
([a(String), b(Int) = 1024]) => a + b; // hxslam
```

* Optional arguments in functions and function types:

```haxe
function(?a:String) return a; // haxe
(-a(String)) => a; // hxslam

function(a:String = "Haxe", ?b:Int) return a + b; // haxe
([a(String) = "Haxe", -b(Int)]) => a + b; // hxslam

function(f:String -> ?Int -> String) return f("Haxe"); // haxe
(f(String > -Int -> String)) => f("Haxe"); // hxslam
```
