package ;

import hxslam.TypedTestCases;
import hxslam.CommonTestCases;
import hxslam.PropertyTestCases;

import utest.Runner;
import utest.ui.Report;
import utest.TestResult;

class TestAll {

    public static function main() {
        var runner = new Runner();
        addTestCases(runner);
        run(runner);
    }

    static function addTestCases(runner:Runner) {
        runner.addCase(new CommonTestCases());
        runner.addCase(new TypedTestCases());
        runner.addCase(new PropertyTestCases());
    }

    static function run(runner:Runner) {
        Report.create(runner);

        // get test result to determine exit status
        var isSuccess:Bool = true;
        runner.onProgress.add(
            function (o) {
                isSuccess = isAllTestsPassed(o.result) && isSuccess;
            }
        );
        runner.onComplete.add(
            function (r) {
                var exitCode = isSuccess ? 0 : -1;

                #if flash
                flash.system.System.exit(exitCode);
                #end

                #if js
                trace("<hxmake::exit>" + exitCode);
                #end
            }
        );

        runner.run();
    }

    static function isAllTestsPassed(result:TestResult):Bool {
        for(l in result.assertations) {
            switch (l) {
                case Success(_):
                case _: return false;
            }
        }
        return true;
    }

}
