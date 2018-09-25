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
  var isFailure = false
  var expectedIndex = 0
  
  func getAllBeers(completion: @escaping (Result<[Beer]>) -> Void) {
    if isFailure {
      completion(Result.fail(.couldNotFoundURL))
    } else {
      completion(Result.success([Beer]()))
    }
  }
  func getBeer(with id: Int, completion: @escaping (Result<Beer>) -> Void) {
    expectedIndex = id
    if isFailure {
      completion(Result.fail(.couldNotFoundURL))
    } else {
      completion(Result.success(Beer(id: 5,
                                     name: "",
                                     tagline: "",
                                     description: "",
                                     imageURL: "",
                                     abv: 0,
                                     ibu: 0)))
    }
  }
}

class MockPresenter: BeersListPresenter {
  var errorWasPresented: Bool = false
  var beerListWasPresented: Bool = false
  
  func showError(error: Error?) {
    errorWasPresented = true
  }
  
  func showBeerList(beers: [BeerCollectionViewModel]) {
    beerListWasPresented = true
  }
  
}

class MockRouter: BeerListRouterProtocol {
  var routeToDetailWasCalled = false
  
  func routeToBeerDetails(with viewModel: BeerDetailViewModel) {
    routeToDetailWasCalled = true
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
  
  func testBeerListWithSuccessResult() {
    sut.beerList()
    
    XCTAssertTrue(presenter.beerListWasPresented)
    XCTAssertFalse(presenter.errorWasPresented)
  }
  
  func testBeerListWithFailResult() {
    gateway.isFailure = true
    
    sut.beerList()
    
    XCTAssertTrue(presenter.errorWasPresented)
    XCTAssertFalse(presenter.beerListWasPresented)
  }
  
  func testGetBeerWithSuccess() {
    let currentIndex = 10
    let expectedIndex = 11
    
    sut.beer(at: currentIndex)
    
    XCTAssertTrue(router.routeToDetailWasCalled)
    XCTAssertEqual(expectedIndex, gateway.expectedIndex)
  }
  
  func testGetBeerWithFailure() {
    gateway.isFailure = true
    let currentIndex = 10
    sut.beer(at: currentIndex)
    
    XCTAssertTrue(presenter.errorWasPresented)
    XCTAssertFalse(router.routeToDetailWasCalled)
  }
  
}
