import Foundation

public protocol ConfigurableCell: ReusableCell {
  associatedtype ViewModel
  
  func bind(_ item: ViewModel, at indexPath: IndexPath)
}
