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
    let currentIndex = 10
    let expectedIndex = 11
    
    sut.beer(at: currentIndex)
    
    XCTAssertTrue(router.routeToDetailWasCalled)
    XCTAssertEqual(expectedIndex, gateway.expectedIndex)
  }
  
  func testGetBeerWithFailure() {
    gateway.isFailure = true
    let currentIndex = 10
    sut.beer(at: currentIndex)
    
    XCTAssertTrue(presenter.errorWasPresented)
    XCTAssertFalse(router.routeToDetailWasCalled)
  }
  
}
