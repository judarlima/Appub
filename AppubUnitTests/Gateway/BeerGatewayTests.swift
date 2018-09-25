import XCTest
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

class BeerGatewayTests: XCTestCase {
    var sut: BeersGateway!
    var service: ServiceMock!
    
    override func setUp() {
        super.setUp()
        service = ServiceMock()
        sut = BeersGateway(service: service)
    }
    
    func testGetAllBeersWithSuccess() {
        let expectedBeers = createBeerList()
        
        sut.getAllBeers { (result) in
            switch result {
            case let .success(resultBeers): XCTAssertEqual(resultBeers, expectedBeers)
            default: XCTFail("Could not return beer collection.")
            }
        }
    }
    
    func testGetAllBeersWithFailure() {
        service.isFailure = true
        let errorMessage = "The operation couldn’t be completed. (Appub.ServiceError error 0.)"
        
        sut.getAllBeers { (result) in
            switch result {
            case let .fail(error):
                XCTAssertNotNil(error)
                XCTAssertEqual(errorMessage, error?.localizedDescription)
            default: XCTFail("Could not validate fail result.")
            }
        }
    }
    
    func testGetBeerWithSucces() {
        let expectedBeer = createBeerList().first!
        let beerId = "5"
        
        sut.getBeer(with: beerId) { (result) in
            switch result {
            case let .success(resultBeer): XCTAssertEqual(expectedBeer, resultBeer)
            default: XCTFail("Could not return beer object.")
            }
        }
    }
    
    func testGetBeerWithFailure() {
        service.isFailure = true
        let beerId = "5"
        let errorMessage = "The operation couldn’t be completed. (Appub.ServiceError error 0.)"
        
        sut.getBeer(with: beerId) { (result) in
            switch result {
            case let .fail(error):
                XCTAssertNotNil(error)
                XCTAssertEqual(errorMessage, error?.localizedDescription)
            default: XCTFail("Could not validate fail result.")
            }
        }
    }
    
    
    
    private func createBeerList() -> [Beer] {
        return [Beer(id: 5,
                     name: "Avery Brown Dredge",
                     tagline: "Bloggers' Imperial Pilsner.",
                     description: "An Imperial Pilsner in collaboration with beer writers. Tradition. Homage." +
                        " Revolution. We wanted to showcase the awesome backbone of the Czech brewing tradition," +
                        " the noble Saaz hop, and also tip our hats to the modern beers that rock our world, " +
            "and the people who make them.",
                     imageURL: "https://images.punkapi.com/v2/5.png",
                     abv: 7.2,
                     ibu: 59.0)]
    }
}
