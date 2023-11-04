import Foundation

public enum ShtEventCommon {
    case create(ShtCreateEvent)
    case show(ShtShowEvent)
    case closed(ShtClosedEvent)
    case click(ShtClickEvent)
//    case stackTrace(ShtStackTrace)
    case api(ShtAPIEvent)
}

public extension ShtEventCommon: CaseIterable {
    public static var allCases: [ShtEventCommon] {
        var result = [ShtEventCommon]()
        ShtCreateEvent.allCases.forEach { result.append(ShtEventCommon.create($0)) }
        ShtShowEvent.allCases.forEach { result.append(ShtEventCommon.show($0)) }
        ShtClosedEvent.allCases.forEach { result.append(ShtEventCommon.closed($0)) }
        ShtClickEvent.allCases.forEach { result.append(ShtEventCommon.click($0)) }
        ShtAPIEvent.allCases.forEach { result.append(ShtEventCommon.api($0)) }        
        return result
    }
    
    
}

public extension ShtEventCommon: ShtEventProtocol {
    public var rawValue: String {
        switch self {
        case .create(let event):        return event.rawValue
        case .show(let event):          return event.rawValue
        case .closed(let event):        return event.rawValue
        case .click(let event):         return event.rawValue
//        case .stackTrace(let event):    return event.trace()
        case .api(let event):           return event.rawValue
        }
    }
    
    public var name: String {
        switch self {
        case .create(let event):        return event.name
        case .show(let event):          return event.name
        case .closed(let event):        return event.name
        case .click(let event):         return event.name
//        case .stackTrace(let event):    return event.name
        case .api(let event):           return event.name
        }
    }
}
