import Foundation

public enum ShtStackTrace: String {
case trace

    public var name: String { "Stack Trace " }

    public func trace() -> String {
        var str =   "************************** Stack Trace **************************\n"
        Thread.current.threadDictionary.forEach { str += "\($0.key) - \($0.value)\n" }
        Thread.callStackSymbols.forEach {str += "\($0)\n"}
        str +=      "*****************************************************************"
        return str
    }
}
