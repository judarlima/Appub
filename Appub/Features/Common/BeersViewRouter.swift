import UIKit

protocol BeerListRouterProtocol {
    func routeToBeerDetails(with viewModel: BeerDetailViewModel)
}

class BeerListRouter: BeerListRouterProtocol {
    weak var viewController: BeerListViewController?
    
    func routeToBeerDetails(with viewModel: BeerDetailViewModel) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "BeerDetail", bundle: nil)
            guard let destinationVC = storyboard.instantiateViewController(withIdentifier: "BeerDetailViewController") as? BeerDetailViewController
                else {
                    fatalError("Could not instantiate BeerDetailViewController")
            }
            _ = destinationVC.view
            destinationVC.bind(viewModel: viewModel)
            self.viewController?.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }  
}
