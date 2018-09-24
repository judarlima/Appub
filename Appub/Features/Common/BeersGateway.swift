import Foundation
import Reachability

protocol BeersGatewayProtocol {
  func getAllBeers(completion: @escaping (Result<[Beer]>) -> Void)
  func getBeer(with id: Int, completion: @escaping (Result<Beer>) -> Void)
}

struct BeersGateway: BeersGatewayProtocol {
  private let service: ServiceProtocol
  
  init(service: ServiceProtocol) {
    self.service = service
  }
  
  func getAllBeers(completion: @escaping (Result<[Beer]>) -> Void) {
    service.requestData(with: BeersGatewaySetup.allBeers) { (responseData, responseError) in
      if let error = responseError {
        completion(Result.fail(ServiceError.failure(error.localizedDescription)))
      }
      else if let data = responseData {
        do {
          let jsonDecoder = JSONDecoder()
          let response = try jsonDecoder.decode([Beer].self, from: data)
          completion(Result.success(response))
        } catch let error {
          completion(Result.fail(ServiceError.unknown(error.localizedDescription)))
        }
      } else {
        completion(Result.fail(ServiceError.couldNotParseResponse))
      }
    }
  }
  
  func getBeer(with id: Int, completion: @escaping (Result<Beer>) -> Void) {
    service.requestData(with: BeersGatewaySetup.singleBeer(id: id)) { (responseData, responseError) in
      if let error = responseError {
        completion(Result.fail(ServiceError.failure(error.localizedDescription)))
      }
      else if let data = responseData {
        do {
          let jsonDecoder = JSONDecoder()
          let response = try jsonDecoder.decode([Beer].self, from: data)
          guard let beer = response.first
            else {
              completion(Result.fail(ServiceError.couldNotParseResponse))
              return
          }
          completion(Result.success(beer))
        } catch let error {
          completion(Result.fail(ServiceError.unknown(error.localizedDescription)))
        }
      } else {
        completion(Result.fail(ServiceError.couldNotParseResponse))
      }
    }
  }
}
