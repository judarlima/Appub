import XCTest
@testable import Appub

class BeersInteractorTests: XCTestCase {
  var sut: BeersInteractor!
  var gateway: BeerGatewayMock!
  var presenter: BeerPresenterMock!
  var router: BeerRouterMock!
  
  override func setUp() {
    
    super.setUp()
    gateway = BeerGatewayMock()
    presenter = BeerPresenterMock()
    router = BeerRouterMock()
    sut = BeersInteractor(gateway: gateway, presenter: presenter, router: router)
  }
  
  func testBeerListWithSuccessResult() {
    sut.beerList()
    
    XCTAssertTrue(presenter.beerListWasPresented)
    XCTAssertFalse(presenter.errorWasPresented)
  }
  
  func testBeerListWithFailResult() {
    gateway.isFailure = true
    
    sut.beerList()
    
    XCTAssertTrue(presenter.errorWasPresented)
    XCTAssertFalse(presenter.beerListWasPresented)
  }
  
  func testGetBeerWithSuccess() {
    let beerId = "10"
    
    sut.beer(with: beerId)
    
    XCTAssertTrue(router.routeToDetailWasCalled)
    XCTAssertEqual(beerId, gateway.expectedId)
  }
  
  func testGetBeerWithFailure() {
    gateway.isFailure = true
    let beerId = "22"
    sut.beer(with: beerId)
    
    XCTAssertTrue(presenter.errorWasPresented)
    XCTAssertFalse(router.routeToDetailWasCalled)
  }
  
}
