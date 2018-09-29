import XCTest
@testable import Appub

class ArrayDataProviderTests: XCTestCase {
    var sut: ArrayDataProvider<Beer>!
    
    override func tearDown() {
        sut = nil
    }
    
    func testCallNumberOfSectionsThenReturnsOne() {
        let beers = TestHelper.createBeerList()
        sut = ArrayDataProvider<Beer>(array: [beers])
        let expectedSectionNumber = 1
        
        let currentSectionNumber = sut.numberOfSections()
        
        XCTAssertEqual(expectedSectionNumber, currentSectionNumber)
        
    }
    
    func testCallNumberOfItemsInSectionWithNonEmptyArrayThenReturnsOne() {
        let beers = TestHelper.createBeerList()
        sut = ArrayDataProvider<Beer>(array: [beers])
        let expectedNumberOfItems = 1
        let sectionNumber = 0
        
        let currentNumberOfItems = sut.numberOfItems(in: sectionNumber)
        
        XCTAssertEqual(expectedNumberOfItems, currentNumberOfItems)
    }
    
    func testCallNumberOfItemsInSectionWithInvalidSectionThenReturnsZero() {
        let beers: [Beer] =  []
        sut = ArrayDataProvider<Beer>(array: [beers])
        let expectedNumberOfItems = 0
        let sectionNumber = -1
        
        let currentNumberOfItems = sut.numberOfItems(in: sectionNumber)
        
        XCTAssertEqual(expectedNumberOfItems, currentNumberOfItems)
    }
    
    func testCallNumberOfItemsInSectionWithEmptyArrayThenReturnsZero() {
        let beers: [Beer] =  []
        sut = ArrayDataProvider<Beer>(array: [beers])
        let expectedNumberOfItems = 0
        let sectionNumber = 0
        
        let currentNumberOfItems = sut.numberOfItems(in: sectionNumber)
        
        XCTAssertEqual(expectedNumberOfItems, currentNumberOfItems)
    }
    
    func testCallItemAtIndexPathWithValidIndexThenReturnBeerItemAtIndex() {
        let beers = [TestHelper.createBeerList()]
        sut = ArrayDataProvider<Beer>(array: beers)
        let indexPath = IndexPath(row: 0, section: 0)
        let expectedItem = beers[indexPath.section][indexPath.row]
        
        let currentItem = sut.item(at: indexPath)
        
        XCTAssertEqual(expectedItem, currentItem)
    }
    
    func testCallItemAtIndexPathWithOutOfRangeIndexThenReturnsNil() {
        let beers = [TestHelper.createBeerList()]
        sut = ArrayDataProvider<Beer>(array: beers)
        let indexPath = IndexPath(row: 0, section: 1)
        
        let currentItem = sut.item(at: indexPath)
        
        XCTAssertNil(currentItem)
    }
    
    func testCallUpdateItemAtIndexPathThenModifyItemAtIndexPath() {
        let beers = [TestHelper.createBeerList()]
        sut = ArrayDataProvider<Beer>(array: beers)
        let indexPath = IndexPath(row: 0, section: 0)
        let initialValue = beers[indexPath.section][indexPath.row]
        let expectedValue = TestHelper.createBeerItem()
        
        sut.updateItem(at: indexPath, value: expectedValue)
        let valueModified = sut.items[indexPath.section][indexPath.row]
        
        XCTAssertEqual(expectedValue, valueModified)
        XCTAssertNotEqual(expectedValue, initialValue)
    }
    
    func testCallUpdateItemAtIndexPathWithOutOfRangeIndexThenNotUpdateItemAtIndexPath() {
        let beers = [TestHelper.createBeerList()]
        sut = ArrayDataProvider<Beer>(array: beers)
        let outOfBoundIndexPath = IndexPath(row: 2, section: 3)
        let correctIndexPath = IndexPath(row: 0, section: 0)
        let valueToModify = TestHelper.createBeerItem()
        
        sut.updateItem(at: outOfBoundIndexPath, value: valueToModify)
        let currentItem = sut.items[correctIndexPath.section][correctIndexPath.row]
        
        XCTAssertNotEqual(valueToModify, currentItem)
        XCTAssertFalse(sut.items.contains([valueToModify]))
    }
    
}
