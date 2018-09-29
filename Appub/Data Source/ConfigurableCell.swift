import Foundation

public protocol ConfigurableCell: ReusableCell {
    associatedtype T
    
    func bind(_ item: T, at indexPath: IndexPath)
}
