import Foundation

public enum ServiceError: Error {
    case couldNotParseResponse
    case couldNotFoundURL
    case noConnection
    case unexpected(Error)
}
