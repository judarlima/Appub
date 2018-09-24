import Foundation

public enum ServiceError: Error {
  case couldNotParseResponse
  case couldNotFoundURL
  case failure(String)
  case unknown(String)
}
