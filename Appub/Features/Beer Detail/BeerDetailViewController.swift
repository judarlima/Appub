import UIKit
import NVActivityIndicatorView

struct BeerDetailViewModel {
  let image: UIImage
  let name: String
  let tagline: String
  let abv: String
  let ibu: String
  let description: String
}

class BeerDetailViewController: UIViewController {
  
  @IBOutlet private weak var beerImage: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var taglineLabel: UILabel!
  @IBOutlet private weak var abvLabel: UILabel!
  @IBOutlet private weak var ibuLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  
  lazy var activityData = ActivityData()
  
  func bind(viewModel: BeerDetailViewModel) {
    beerImage.image = viewModel.image
    nameLabel.text = "name: " + viewModel.name
    taglineLabel.text = "tagline: " + viewModel.tagline
    abvLabel.text = "abv: " + viewModel.abv
    ibuLabel.text = "ibu: " + viewModel.ibu
    descriptionLabel.text = viewModel.description
  }
  
  override func viewDidLoad() {
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
  }
}
