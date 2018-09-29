import UIKit
import NVActivityIndicatorView

open class CollectionDataSource<Provider: CollectionDataProvider, Cell: UICollectionViewCell>:
  NSObject,
  UICollectionViewDelegate,
  UICollectionViewDataSource
where Cell: ConfigurableCell, Provider.T == Cell.T {
  
  public typealias CollectionItemSelectionHandlerType = (IndexPath) -> Void
  
  // MARK: - Properties
  let provider: Provider
  private let collectionView: UICollectionView
  private lazy var activityData = ActivityData()
  
  // MARK: - Lifecycle
  init(collectionView: UICollectionView, provider: Provider) {
    self.collectionView = collectionView
    self.provider = provider
    super.init()
    setUp()
  }
  
  func setUp() {
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  // MARK: - UICollectionViewDataSource
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return provider.numberOfSections()
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return provider.numberOfItems(in: section)
  }
  
  //Setted as open in case any subclass requires more customization during the cell content initialization phase.
  open func collectionView(_ collectionView: UICollectionView,
                           cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
                                                        for: indexPath) as? Cell else {
                                                          return UICollectionViewCell()
    }
    let item = provider.item(at: indexPath)
    if let item = item {
      cell.bind(item, at: indexPath)
    }
    return cell
  }
  
  // MARK: - Delegates
  public var collectionItemSelectionHandler: CollectionItemSelectionHandlerType?
  
  // MARK: - UICollectionViewDelegate
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
      collectionItemSelectionHandler?(indexPath)
  }
  
  open func collectionView(_ collectionView: UICollectionView,
                           viewForSupplementaryElementOfKind kind: String,
                           at indexPath: IndexPath) -> UICollectionReusableView {
    return UICollectionReusableView(frame: CGRect.zero)
  }
  
}
