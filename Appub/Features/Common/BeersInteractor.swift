import Foundation
import Kingfisher

protocol BeersListPresenter {
    func showBeerList(beers: [BeerCollectionViewModel])
    func showError(error: Error?)
}

class BeersInteractor {
    private let gateway: BeersGatewayProtocol
    private let presenter: BeersListPresenter
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
                let beersViewModel = allBeers.map(BeerCollectionViewModel.init)
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
                let viewModel = BeerDetailViewModel(beer: beer)
                interactor.router.routeToBeerDetails(with: viewModel)
            case let .fail(error):
                interactor.presenter.showError(error: error)
            }
        }
    }
}
