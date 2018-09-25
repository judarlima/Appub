import UIKit
import NVActivityIndicatorView

struct BeerDetailViewModel {
  let imageURL: String
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
  @IBOutlet weak var scrollView: UIScrollView!
  
  lazy var activityData = ActivityData()
  
  func bind(viewModel: BeerDetailViewModel) {
    let imageURL = URL(string: viewModel.imageURL)
    beerImage.kf.setImage(with: imageURL)
    nameLabel.text = "name: " + viewModel.name
    taglineLabel.text = "tagline: " + viewModel.tagline
    abvLabel.text = "abv: " + viewModel.abv
    ibuLabel.text = "ibu: " + viewModel.ibu
    descriptionLabel.text = viewModel.description
  }
  
  override func viewDidLoad() {
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    setupScrollView()
  }
  
  private func setupScrollView() {
    let scrollSize = CGSize(width: self.view.frame.size.width,
                            height: self.view.frame.size.height)
    scrollView.contentSize = scrollSize
    scrollView.isDirectionalLockEnabled = true
//    scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true

  }
}
