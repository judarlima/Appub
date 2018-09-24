//
//  BeersInteractorTests.swift
//  AppubUnitTests
//
//  Created by Judar Lima on 9/24/18.
//  Copyright © 2018 Raduj. All rights reserved.
//

import XCTest
@testable import Appub

class MockGateway: BeersGatewayProtocol {
  func getAllBeers(completion: @escaping (Result<[Beer]>) -> Void) {
    //
  }
  func getBeer(with id: Int, completion: @escaping (Result<Beer>) -> Void) {
    //
  }
}

class MockPresenter: BeersListPresenter {
  func showError(error: Error?) {
    //
  }
  
  func showBeerList(beers: [BeerCollectionViewModel]) {
    //
  }
  
}

class MockRouter: BeerListRouterProtocol {
  func routeToBeerDetails(with viewModel: BeerDetailViewModel) {
    //
  }
}

class BeersInteractorTests: XCTestCase {
  var sut: BeersInteractor!
  var gateway: MockGateway!
  var presenter: MockPresenter!
  var router: MockRouter!
  
  override func setUp() {
    super.setUp()
    gateway = MockGateway()
    presenter = MockPresenter()
    router = MockRouter()
    sut = BeersInteractor(gateway: gateway, presenter: presenter, router: router)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
