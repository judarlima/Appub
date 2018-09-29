import UIKit

open class CollectionArrayDataSource<ViewModel, Cell: UICollectionViewCell>: CollectionDataSource<ArrayDataProvider<ViewModel>, Cell>
where Cell: ConfigurableCell, Cell.ViewModel == ViewModel {
  
  public convenience init(collectionView: UICollectionView, array: [ViewModel]) {
    self.init(collectionView: collectionView, array: [array])
  }
  
  public init(collectionView: UICollectionView, array: [[ViewModel]]) {
    let provider = ArrayDataProvider(array: array)
    super.init(collectionView: collectionView, provider: provider)
  }
  
  public func item(at indexPath: IndexPath) -> ViewModel? {
    return provider.item(at: indexPath)
  }
  
  public func updateItem(at indexPath: IndexPath, value: ViewModel) {
    provider.updateItem(at: indexPath, value: value)
  }
  
}
