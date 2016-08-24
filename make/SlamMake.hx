import hxmake.test.TestTask;
import hxmake.haxelib.HaxelibExt;
import hxmake.idea.IdeaPlugin;
import hxmake.haxelib.HaxelibPlugin;

using hxmake.haxelib.HaxelibPlugin;

class EcxMake extends hxmake.Module {

    function new() {
        config.classPath = ["src"];
        config.testPath = ["tests"];
        config.devDependencies = [
            "utest" => "haxelib"
        ];

        apply(HaxelibPlugin);
        apply(IdeaPlugin);

        library(function(ext:HaxelibExt) {
            ext.config.version = "0.3.0";
            ext.config.description = "Short lambda cross platform library.";
            ext.config.url = "https://github.com/bynuff/hxslam";
            ext.config.tags = ["lambda", "short lambda", "cross", "utility", "sugar"];
            ext.config.contributors = ["bynuff"];
            ext.config.license = "MIT";
            ext.config.releasenote = "Short lambdas for properties. Get/set methods generation with override support.";

            ext.pack.includes = ["src", "haxelib.json", "README.md", "extraParams.hxml"];
        });

        var tt = new TestTask();
        tt.debug = true;
        tt.targets = ["neko", "swf", "node", "js", "cpp", "java", "cs"];
        tt.libraries = ["hxslam"];
        task("tests", tt);
    }

}