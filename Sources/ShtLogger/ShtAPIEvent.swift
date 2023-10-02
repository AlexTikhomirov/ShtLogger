import Foundation

public enum ShtAPIEvent: String, CaseIterable {
    case error          = "Error Server"
    case request        = "Request Server"
    case response       = "Response Server"
    case statusCode     = "Response status code"
    case post           = "POST"
    case `get`          = "GET"
    case put            = "PUT"
    case delete         = "DELETE"
    case upload         = "UPLOAD"
    case download       = "DOWNLOAD"

    public var name: String { "API Server  " }
}
