import UIKit

class BeersDataSource: CollectionArrayDataSource<BeerCollectionViewModel, BeerCollectionViewCell>, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset
        let rightSpace: CGFloat = 10
        let itemSize = (collectionView.frame.width - (contentInset.left + contentInset.right + rightSpace)) / 2
        
        return CGSize(width: itemSize, height: itemSize)
    }
}
