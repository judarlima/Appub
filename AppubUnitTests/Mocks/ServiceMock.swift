import Foundation
@testable import Appub

class ServiceMock: ServiceProtocol {
  var isFailure = false
  
  func requestData(with setup: ServiceSetup, completion: @escaping (Data?, ServiceError?) -> Void) {
    if isFailure {
      completion(nil, ServiceError.couldNotParseResponse)
    } else {
      completion(TestHelper.jsonData(), nil)
    }
  }
}
