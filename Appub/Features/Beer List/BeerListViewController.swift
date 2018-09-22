//
//  BeerListViewController.swift
//  Appub
//
//  Created by Judar Lima on 9/22/18.
//  Copyright © 2018 Raduj. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BeerListViewController: UICollectionViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  private func setupView() {
    self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView?.backgroundColor = .clear
    collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell",
                                                        for: indexPath) as? BeerCollectionViewCell
      else {
        return UICollectionViewCell()
    }
    return cell
  }
  
}

extension BeerListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let contentInset = collectionView.contentInset
    let rightSpace: CGFloat = 10
    let itemSize = (collectionView.frame.width - (contentInset.left + contentInset.right + rightSpace)) / 2
    
    return CGSize(width: itemSize, height: itemSize)
  }
}
