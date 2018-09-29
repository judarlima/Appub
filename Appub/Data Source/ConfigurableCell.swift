import Foundation

public protocol ConfigurableCell: ReusableCell {
  associatedtype T
  
  func configure(_ item: T, at indexPath: IndexPath)
}
