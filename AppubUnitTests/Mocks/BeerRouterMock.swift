import XCTest
@testable import Appub

class BeerRouterMock: BeerListRouterProtocol {
    var routeToDetailWasCalled = false
    
    func routeToBeerDetails(with viewModel: BeerDetailViewModel) {
        routeToDetailWasCalled = true
    }
}
