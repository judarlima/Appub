import Foundation
import Kingfisher

protocol BeersListPresenter {
  func showBeerList(beers: [BeerCollectionViewModel])
  func showError(error: Error?)
}

class BeersInteractor {
  private let gateway: BeersGatewayProtocol
  private let presenter: BeersListPresenter
  private var allBeers: [Beer] = []
  private var router: BeerListRouterProtocol
  
  init(gateway: BeersGatewayProtocol,
       presenter: BeersListPresenter,
       router: BeerListRouterProtocol) {
    self.gateway = gateway
    self.presenter = presenter
    self.router = router
  }
  
  func beerList() {
    gateway.getAllBeers { [weak self] (result) in
      guard let interactor = self else { return }
      switch result {
      case let .success(allBeers):
        interactor.allBeers = allBeers
        let beersViewModel = allBeers.map({ BeerCollectionViewModel(id: String($0.id)
                                                                    beerImage: $0.imageURL,
                                                                    beerNameLabel: $0.name,
                                                                    beerAbvLabel: String($0.abv)) })
        interactor.presenter.showBeerList(beers: beersViewModel)
      case .fail(let error):
        interactor.presenter.showError(error: error)
      }
    }
  }
  
  func beer(with id: String) {
    gateway.getBeer(with: id) { [weak self] (result) in
      guard let interactor = self else { return }
      switch result {
      case let .success(beer):
        let beerIbu = beer.ibu != nil ? "\(beer.ibu!)" : "N/A"
        let beerViewModel = BeerDetailViewModel(imageURL: beer.imageURL,
                                                name: beer.name,
                                                tagline: beer.tagline,
                                                abv: "\(beer.abv)",
          ibu: beerIbu,
          description: beer.description)
        
        interactor.router.routeToBeerDetails(with: beerViewModel)
      case let .fail(error):
        interactor.presenter.showError(error: error)
      }
    }
  }
}
