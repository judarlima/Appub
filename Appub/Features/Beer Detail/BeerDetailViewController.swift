import UIKit

class BeerDetailViewController: UIViewController {
  @IBOutlet private var beerView: BeerDetailView!
  
  override func viewDidLoad() {
    self.beerView = BeerDetailView(frame: .zero)
  }
  
  func setupBeerView(viewModel: BeerDetailViewModel) {
    beerView.bind(viewModel: viewModel)
  }
}
