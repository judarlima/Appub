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
        var beersViewModel: [BeerCollectionViewModel] = []
        allBeers.forEach({ (beer) in
          guard let imageURL = URL(string: beer.imageURL) else { return }
          let beerImage = interactor.downloadBeerImage(url: imageURL)
          beersViewModel.append(BeerCollectionViewModel(beerImage: beerImage,
                                  beerNameLabel: beer.name,
                                  beerAbvLabel: String(beer.abv)))
        })
        interactor.presenter.showBeerList(beers: beersViewModel)
      case .fail(let error):
        interactor.presenter.showError(error: error)
      }
    }
  }
  
  func beer(at index: Int) {
    gateway.getBeer(with: index) { [weak self] (result) in
      guard let interactor = self else { return }
      switch result {
      case let .success(beer):
        let beerIbu = beer.ibu != nil ? "\(beer.ibu!)" : "N/A"
        guard let imageURL = URL(string: beer.imageURL) else { return }
        let beerImage = interactor.downloadBeerImage(url: imageURL)
        let beerViewModel = BeerDetailViewModel(image: beerImage,
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
  
  private func downloadBeerImage(url: URL) -> UIImage {
    var beerImage: UIImage!
    ImageDownloader.default.downloadImage(with: url, completionHandler: { (image, _, _, _) in
      if let downloadedImage = image?.images?.first {
        beerImage = downloadedImage
      } else {
        beerImage = UIImage()
      }
    })
    return beerImage
  }
}
