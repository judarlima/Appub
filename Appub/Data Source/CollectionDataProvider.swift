import Foundation

public protocol CollectionDataProvider {
  associatedtype ViewModel
  
  func numberOfSections() -> Int
  func numberOfItems(in section: Int) -> Int
  func item(at indexPath: IndexPath) -> ViewModel?
  
  func updateItem(at indexPath: IndexPath, value: ViewModel)
}
