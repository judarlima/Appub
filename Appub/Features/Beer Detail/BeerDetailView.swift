import UIKit
import Kingfisher

struct BeerDetailViewModel {
  let imageURL: String
  let name: String
  let tagline: String
  let abv: String
  let ibu: String
  let description: String
}

class BeerDetailView: UIView {
  
  @IBOutlet weak var beerImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var taglineLabel: UILabel!
  @IBOutlet weak var abvLabel: UILabel!
  @IBOutlet weak var ibuLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func bind(viewModel: BeerDetailViewModel) {
    let imageURL = URL(string: viewModel.imageURL)
    beerImage.kf.setImage(with: imageURL)
    nameLabel.text = viewModel.name
    taglineLabel.text = viewModel.tagline
    abvLabel.text = viewModel.abv
    ibuLabel.text = viewModel.ibu
    descriptionLabel.text = viewModel.description
  }
  
}
