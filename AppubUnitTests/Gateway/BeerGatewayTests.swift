import XCTest
@testable import Appub

class BeerGatewayTests: XCTestCase {
    var sut: BeersGateway!
    var service: ServiceMock!
    
    override func setUp() {
        super.setUp()
        service = ServiceMock()
        sut = BeersGateway(service: service)
    }
    
    func testGetAllBeersSuccessWhenServiceReturnJsonData() {
        let expectedBeers = TestHelper.createBeerList()
        
        sut.getAllBeers { (result) in
            switch result {
            case let .success(resultBeers): XCTAssertEqual(resultBeers, expectedBeers)
            default: XCTFail("Could not return beer collection.")
            }
        }
    }
    
    func testGetAllBeersFailWhenServiceReturnServiceError() {
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
    
    func testGetBeerSuccessWhenServiceReturnJsonData() {
        let expectedBeer = TestHelper.createBeerList().first!
        let beerId = "5"
        
        sut.getBeer(with: beerId) { (result) in
            switch result {
            case let .success(resultBeer): XCTAssertEqual(expectedBeer, resultBeer)
            default: XCTFail("Could not return beer object.")
            }
        }
    }
    
    func testGetBeerWithEmptyBeerArrayThenReturServiceError() {
        
    }
    
    func testGetBeerFailWhenServiceReturnServiceError() {
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
}
