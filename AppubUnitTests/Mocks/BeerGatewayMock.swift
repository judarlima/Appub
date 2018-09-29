import Foundation
@testable import Appub

class BeerGatewayMock: BeersGatewayProtocol {
    var isFailure = false
    var expectedId: String = ""
    
    func getAllBeers(completion: @escaping (Result<[Beer]>) -> Void) {
        if isFailure {
            completion(Result.fail(.couldNotFoundURL))
        } else {
            completion(Result.success([Beer]()))
        }
    }
    
    func getBeer(with id: String, completion: @escaping (Result<Beer>) -> Void) {
        expectedId = id
        if isFailure {
            completion(Result.fail(.couldNotFoundURL))
        } else {
            completion(Result.success(Beer(id: 5,
                                           name: "",
                                           tagline: "",
                                           description: "",
                                           imageURL: "",
                                           abv: 0,
                                           ibu: 0)))
        }
    }
}

