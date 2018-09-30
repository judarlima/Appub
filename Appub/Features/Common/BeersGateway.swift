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
            self.generateResult(responseData: responseData, responseError: responseError, completion: { (result, error) in
                if let beers = result {
                    completion(Result.success(beers))
                } else {
                    completion(Result.fail(error))
                }
            })
        }
    }
    
    func getBeer(with id: String, completion: @escaping (Result<Beer>) -> Void) {
        service.requestData(with: BeersGatewaySetup.singleBeer(id: id)) { (responseData, responseError) in
            self.generateResult(responseData: responseData, responseError: responseError, completion: { (result, error) in
                guard let beerArray = result
                    else {
                        completion(Result.fail(error))
                        return
                }
                guard let beer = beerArray.first
                    else {
                        completion(Result.fail(ServiceError.couldNotParseResponse))
                        return
                }
                completion(Result.success(beer))
            })
        }
    }
    
    private func generateResult(responseData: Data?, responseError: ServiceError?, completion: @escaping ([Beer]?, ServiceError?) -> Void ) {
        if let error = responseError {
            completion(nil, ServiceError.unexpected(error))
        }
        else if let data = responseData {
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode([Beer].self, from: data)
                completion(response, nil)
            } catch let error {
                completion(nil, ServiceError.unexpected(error))
            }
        } else {
            completion(nil, ServiceError.couldNotParseResponse)
        }
    }
}
