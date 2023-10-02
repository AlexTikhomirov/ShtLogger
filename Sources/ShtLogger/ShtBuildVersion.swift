import Foundation

public enum ShtBuildVersion {
    case early
    case actual
    case latest
    case unknown
    
    public static func ver() -> String {
        if let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return versionNumber
        } else {
            return "unknown"
        }
    }
    
    public static func verFull() -> String {
        if let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String, let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return versionNumber + "." + buildNumber
        } else {
            return "unknown"
        }
    }
    
    public static func checkVersion(_ version: String) -> ShtBuildVersion {
        let verSelf = verFull()
        var count = 2
        if verSelf == "unknown" { return .unknown }
        if version == verSelf { return .actual }
        let sours = version.split(separator: ".").compactMap { Int($0) }
        let dests = verSelf.split(separator: ".").compactMap { Int($0) }
        if sours.count < 2 || dests.count < 2 { return .unknown }
        if dests.count < sours.count {
            count = dests.count
        } else if sours.count < dests.count {
            count = sours.count
        } else {
            count = dests.count
        }
        for i in 0..<count {
            if dests[i] < sours[i] {
                return .latest
            } else if dests[i] > sours[i] {
                return .early
            }
        }
        if dests.count < sours.count {
            return .latest
        } else if dests.count > sours.count {
            return .early
        } else {
            return .actual
        }
    }
}
