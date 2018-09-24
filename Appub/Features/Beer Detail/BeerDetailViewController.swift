import UIKit

struct BeerDetailViewModel {
  let imageURL: String
  let name: String
  let tagline: String
  let abv: String
  let ibu: String
  let description: String
}

class BeerDetailViewController: UIViewController {
  
  var loadingView: LoadingView!
  
  @IBOutlet private weak var beerImage: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var taglineLabel: UILabel!
  @IBOutlet private weak var abvLabel: UILabel!
  @IBOutlet private weak var ibuLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  
  func bind(viewModel: BeerDetailViewModel) {
    let imageURL = URL(string: viewModel.imageURL)
    beerImage.kf.setImage(with: imageURL)
    nameLabel.text = "name: " + viewModel.name
    taglineLabel.text = "tagline: " + viewModel.tagline
    abvLabel.text = "abv: " + viewModel.abv
    ibuLabel.text = "ibu: " + viewModel.ibu
    descriptionLabel.text = viewModel.description
  }
  
  func hide(loadingView: LoadingView) {
    self.loadingView = loadingView
    loadingView.hide()
  }
  
}
