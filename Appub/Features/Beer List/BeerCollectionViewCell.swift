//
//  BeerListCollectionViewCell.swift
//  Appub
//
//  Created by Judar Lima on 9/22/18.
//  Copyright © 2018 Raduj. All rights reserved.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var beerImage: UIImageView!
  @IBOutlet weak var beerNameLabel: UILabel!
  @IBOutlet weak var beerAbvLabel: UILabel!
  @IBOutlet weak var containerView: UIView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
  }
}
