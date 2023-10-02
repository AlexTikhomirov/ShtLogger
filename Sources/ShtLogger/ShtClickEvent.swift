import Foundation

public enum ShtClickEvent: String, CaseIterable {
    case button         = "Click button"
    case cell           = "Click cell"
    case tabBar         = "Click tabBar item"
    case topBar         = "Click topBar item"
    case control        = "Click control"

    public var name: String { "Click Event " }
}
