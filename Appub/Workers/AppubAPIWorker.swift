//
//  AppubAPIWorker.swift
//  Appub
//
//  Created by Judar Lima on 9/22/18.
//  Copyright © 2018 Raduj. All rights reserved.
//

import Foundation
import Reachability

enum AppubAPIError: Error {
  case NoConnection
  case CouldNotParseResponse
  case Failure(String)
  case Unknown
}

class AppubAPIWorker {
  
  private let baseURL = "https://api.punkapi.com/v2"
  private let httpRequestsWorker = HTTPRequestsWorker()
  
  //MARK: Singleton Definition
  private static var instance: AppubAPIWorker?
  static var sharedInstance: AppubAPIWorker {
    get {
      if instance == nil {
        instance = AppubAPIWorker()
      }
      return instance!
    }
  }
  
  private init() {}
  
  // MARK: Auxiliary methods
  
  private func canReachNetwork() -> Bool {
    if let reachAbility = Reachability(), reachAbility.connection != .none {
      return true
    } else {
      return false
    }
  }
  
  private func getAppubError(from httpError: ServiceError) -> AppubAPIError {
    switch httpError {
    case .CouldNotFoundURL:
      return .Failure("A API Punk não está respondendo.")
    case .CouldNotParseResponse:
      return .CouldNotParseResponse
    case .Failure(let data):
      return .Failure(data)
    case .Unknown(_):
      return .Unknown
    }
  }
  
  // MARK: API capabilities
//  public func getAllBeers(_ completion: @escaping ([Beer]?, AppubAPIError?) -> Void) {
//
//  }
  
//  private var imagePromises: [Promise<(beers: [Beer], image: UIImage)>]!
  
  public func fetchAllBeers(_ completion: @escaping ([Beer]?, AppubAPIError?) -> Void) {
    guard self.canReachNetwork() else {
      completion(nil, .Failure("Não foi possível recuperar os end points da API."))
      return
    }
    let beersEndpoint = "\(baseURL)/beers"
    self.httpRequestsWorker.getHTTP(at: beersEndpoint) { [weak self] (beers: [Beer]?, error) in
      if let allBeers = beers {
        completion(allBeers, nil)
      }
      else if let error = error {
        completion(nil, self?.getAppubError(from: error))
      }
    }
    
  }
  
  //  private func downloadAllImages(for beers: [Beer], _ completion: @escaping ([Beer]) -> Void) {
  //    self.imagePromises = beers.map({ (beer) -> Promise<(beer: Beer, image: UIImage)> in
  //      return Promise<(beer: Beer, image: UIImage)> { imagePromise in
  //        self.httpRequestsWorker.getHTTP(at: beer.imageURL) { (data, error) in
  //          if let imageData = data, let image = UIImage(data: imageData) {
  //            package.image = image
  //            imagePromise.resolve((travelPackage: package, image: image), nil)
  //          } else if let error = error {
  //            imagePromise.reject(error)
  //          } else {
  //            imagePromise.reject(ViajabessaAPIError.Unknown)
  //          }
  //        }
  //      }
  //    })
  //
  //    _ = when(resolved: self.imagePromises).done({ results in
  //      for result in results {
  //        switch result {
  //        case .fulfilled(let travelPackage, let image):
  //          travelPackage.image = image
  //        case .rejected(_):
  //          break
  //        }
  //      }
  //    }).done({ _ in
  //      DispatchQueue.main.async {
  //        completion(travelPackages)
  //      }
  //    })
  //  }
}
