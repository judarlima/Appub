import Foundation
import Reachability

protocol BeersGatewayProtocol {
    func getAllBeers(completion: @escaping (Result<[Beer]>) -> Void)
    func getBeer(with id: String, completion: @escaping (Result<Beer>) -> Void)
}

struct BeersGateway: BeersGatewayProtocol {
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    func getAllBeers(completion: @escaping (Result<[Beer]>) -> Void) {
        service.requestData(with: BeersGatewaySetup.allBeers) { (responseData, responseError) in
            completion(self.generateResult(responseData: responseData, responseError: responseError))
        }
    }
    
    func getBeer(with id: String, completion: @escaping (Result<Beer>) -> Void) {
        service.requestData(with: BeersGatewaySetup.singleBeer(id: id)) { (responseData, responseError) in
            let result = self.generateResult(responseData: responseData, responseError: responseError)
            switch result {
            case let .success(beerArray):
                guard let beer = beerArray.first
                    else {
                        completion(Result.fail(ServiceError.couldNotParseResponse))
                        return
                }
                completion(Result.success(beer))
            case let .fail(error): completion(Result.fail(error))
            }
        }
    }
    
    private func generateResult(responseData: Data?, responseError: ServiceError?) -> Result<[Beer]> {
        if let error = responseError {
            return Result.fail(ServiceError.unexpected(error))
        }
        else if let data = responseData {
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode([Beer].self, from: data)
                return Result.success(response)
            } catch let error {
                return Result.fail(ServiceError.unexpected(error))
            }
        } else {
            return Result.fail(ServiceError.couldNotParseResponse)
        }
    }
}
