import Foundation

public enum ShtCreateEvent: String, CaseIterable {
    case controller     = "Created view controller"
    case view           = "Created view"
    case application    = "Created application version"

    public var name: String { "Create Event" }
}
