import Foundation
import Reachability

protocol ServiceProtocol {
  func requestData(with setup: ServiceSetup, completion: @escaping (Data?, ServiceError?) -> Void)
}

struct APIService: ServiceProtocol {
  
  public func requestData(with setup: ServiceSetup, completion: @escaping (Data?, ServiceError?) -> Void) {
    guard canReachNetwork() else {
      completion(nil, .noConnection)
      return
    }
    guard let url = URL(string: setup.endpoint) else {
      completion(nil, .couldNotFoundURL)
      return
    }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print(error.localizedDescription)
        completion(nil, .unexpected(error))
      } else if let data = data {
        completion(data, nil)
      } else {
        completion(nil, .couldNotParseResponse)
      }
      }.resume()
  }
  
  private func canReachNetwork() -> Bool {
    if let reachAbility = Reachability(), reachAbility.connection != .none {
      return true
    } else {
      return false
    }
  }
}
