//
//  BeerListCollectionViewCell.swift
//  Appub
//
//  Created by Judar Lima on 9/22/18.
//  Copyright © 2018 Raduj. All rights reserved.
//

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
    beerNameLabel.text = viewModel.beerNameLabel
    beerAbvLabel.text = viewModel.beerAbvLabel
  }
  
  private func makeRounded() {
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
  }
}
