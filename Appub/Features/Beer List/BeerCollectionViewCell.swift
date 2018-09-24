import UIKit
import Kingfisher

class BeerCollectionViewCell: UICollectionViewCell {
  @IBOutlet private weak var beerImage: UIImageView!
  @IBOutlet private weak var beerNameLabel: UILabel!
  @IBOutlet private weak var beerAbvLabel: UILabel!
  @IBOutlet private weak var containerView: UIView!

  override func awakeFromNib() {
    super.awakeFromNib()
    makeRounded()
  }
  
  func bind(viewModel: BeerCollectionViewModel) {
    let imageURL = URL(string: viewModel.beerImage)
    beerImage.kf.setImage(with: imageURL)
    beerNameLabel.text = "name: " + viewModel.beerNameLabel
    beerAbvLabel.text = "abv: " + viewModel.beerAbvLabel
  }
  
  private func makeRounded() {
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
  }
}
