import UIKit

protocol BeerListRouterProtocol {
  func routeToBeerDetails(with viewModel: BeerDetailViewModel)
}

class BeerListRouter: BeerListRouterProtocol {
  weak var viewController: BeerListViewController?
  
  func routeToBeerDetails(with viewModel: BeerDetailViewModel) {
    let storyboard = UIStoryboard(name: "BeerDetail", bundle: nil)
    guard let destinationVC = storyboard.instantiateViewController(withIdentifier: "BeerDetailViewController") as? BeerDetailViewController
      else {
        fatalError("Could not instantiate BeerDetailViewController")
    }
    destinationVC.setupBeerView(viewModel: viewModel)
    navigateToSeeMovieDetails(source: viewController!, destination: destinationVC)
  }

  func navigateToSeeMovieDetails(source: BeerListViewController, destination: BeerDetailViewController) {
      source.navigationController?.pushViewController(destination, animated: true)
    }
}
