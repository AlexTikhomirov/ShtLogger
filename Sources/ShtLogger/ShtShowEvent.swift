import Foundation

public enum ShtShowEvent: String, CaseIterable {
    case controller = "Showed view Controller"
    case view       = "Showed view"
    case alert      = "Showed alert"
    
    var name: String { "Show Event  " }
}
