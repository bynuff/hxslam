package hxslam.common;

interface IContext<T> {
    function createProcess():Process<T>;
    function endProcess(process:Process<T>):Void;
    function getResults():Array<T>;
}
