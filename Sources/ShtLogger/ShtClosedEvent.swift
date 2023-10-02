import Foundation

public enum ShtClosedEvent: String, CaseIterable {
    case controller = "Closed ViewController"
    case view       = "Closed view"

    public var name: String { "Close Event " }
}
