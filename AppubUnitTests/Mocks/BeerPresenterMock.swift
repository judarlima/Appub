import XCTest
@testable import Appub

class BeerPresenterMock: BeersListPresenter {
  var errorWasPresented: Bool = false
  var beerListWasPresented: Bool = false
  
  func showError(error: Error?) {
    errorWasPresented = true
  }
  
  func showBeerList(beers: [BeerCollectionViewModel]) {
    beerListWasPresented = true
  }
  
}
