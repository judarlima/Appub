//
//  AppubAPIWorker.swift
//  Appub
//
//  Created by Judar Lima on 9/22/18.
//  Copyright © 2018 Raduj. All rights reserved.
//

import Foundation
import Reachability
import PromiseKit

enum ViajabessaAPIError: Error {
  case NoConnection
  case CouldNotParseResponse
  case Failure(String)
  case Unknown
}

class ViajabessaAPIWorker {
  
  private let apiURLString = "https://private-a3e3bd-viajabessa62.apiary-mock.com/"
  
  private struct EndPoints: Decodable {
    let transactions: String
    let packages: String
    
    private enum CodingKeys: String, CodingKey {
      case transactions   = "transacoes_url"
      case packages     = "pacotes_url"
    }
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      transactions = try values.decode(String.self, forKey: .transactions)
      packages = try values.decode(String.self, forKey: .packages)
    }
  }
  private var endPoints: EndPoints? = nil
  
  private let httpRequestsWorker = HTTPRequestsWorker()
  
  //MARK: Singleton Definition
  private static var theOnlyInstance: ViajabessaAPIWorker?
  static var shared: ViajabessaAPIWorker {
    get {
      if theOnlyInstance == nil {
        theOnlyInstance = ViajabessaAPIWorker()
      }
      return theOnlyInstance!
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
  
  private func getEndPoints(_ completion: ((ViajabessaAPIError?) -> Void)? = nil) {
    guard self.canReachNetwork() else {
      completion?(.NoConnection)
      return
    }
    
    self.httpRequestsWorker.getHTTP(at: self.apiURLString) { (endPoints: EndPoints?, error) in
      if let endPoints = endPoints {
        self.endPoints = endPoints
        completion?(nil)
      } else if let error = error {
        completion?(self.getVAError(from: error))
      } else {
        completion?(.Unknown)
      }
    }
  }
  
  private func getVAError(from httpError: HTTPRequestsError) -> ViajabessaAPIError {
    switch httpError {
    case .CouldNotFormURL:
      return .Failure("Entre em contato com a Viajabessa.")
    case .CouldNotParseResponse:
      return .CouldNotParseResponse
    case .Failure(let data):
      return .Failure(data)
    case .Unknown(_):
      return .Unknown
    }
  }
  
  // MARK: API capabilities
  
  public func getAllTravelPackages(_ completion: @escaping ([TravelPackage]?, ViajabessaAPIError?) -> Void) {
    guard self.canReachNetwork() else {
      completion(nil, .NoConnection)
      return
    }
    
    if self.endPoints == nil {
      self.getEndPoints() { (error) in
        if let error = error {
          completion(nil, error)
        } else {
          self.fetchTravelPackages(completion)
        }
      }
    } else {
      self.fetchTravelPackages(completion)
    }
  }
  
  private var imagePromises: [Promise<(travelPackage: TravelPackage, image: UIImage)>]!
  
  private func fetchTravelPackages(_ completion: @escaping ([TravelPackage]?, ViajabessaAPIError?) -> Void) {
    guard self.canReachNetwork() else {
      completion(nil, .NoConnection)
      return
    }
    
    if let packageEndPoint = self.endPoints?.packages {
      self.httpRequestsWorker.getHTTP(at: self.apiURLString + packageEndPoint) { (travelPackages: [TravelPackage]?, error) in
        if let travelPackages = travelPackages {
          self.downloadAllImages(for: travelPackages, { (packagesWithImages) in
            completion(travelPackages, nil)
          })
        } else if let error = error {
          completion(nil, self.getVAError(from: error))
        } else {
          completion(nil, .Unknown)
        }
      }
    } else {
      completion(nil, .Failure("Não foi possível recuperar os end points da API."))
    }
  }
  
  private func downloadAllImages(for travelPackages: [TravelPackage], _ completion: @escaping ([TravelPackage]) -> Void) {
    self.imagePromises = travelPackages.map({ (package) -> Promise<(travelPackage: TravelPackage, image: UIImage)> in
      return Promise<(travelPackage: TravelPackage, image: UIImage)> { imagePromise in
        self.httpRequestsWorker.getHTTP(at: package.imageURLString) { (data, error) in
          if let imageData = data, let image = UIImage(data: imageData) {
            package.image = image
            imagePromise.resolve((travelPackage: package, image: image), nil)
          } else if let error = error {
            imagePromise.reject(error)
          } else {
            imagePromise.reject(ViajabessaAPIError.Unknown)
          }
        }
      }
    })
    
    _ = when(resolved: self.imagePromises).done({ results in
      for result in results {
        switch result {
        case .fulfilled(let travelPackage, let image):
          travelPackage.image = image
        case .rejected(_):
          break
        }
      }
    }).done({ _ in
      DispatchQueue.main.async {
        completion(travelPackages)
      }
    })
  }
  
  public func buyPackage(with transaction: Transaction, _ completion: @escaping (ViajabessaAPIError?) -> Void) {
    guard self.canReachNetwork() else {
      completion(.NoConnection)
      return
    }
    
    if self.endPoints == nil {
      self.getEndPoints() { (error) in
        if let error = error {
          completion(error)
        } else {
          self.postTransaction(transaction, completion)
        }
      }
    } else {
      self.postTransaction(transaction, completion)
    }
  }
  
  private func postTransaction(_ transaction: Transaction, _ completion: @escaping (ViajabessaAPIError?) -> Void) {
    if let transactionsEndPoint = self.endPoints?.transactions {
      self.httpRequestsWorker.postHTTP(at: self.apiURLString + transactionsEndPoint, withEncodableObj: transaction) { (response, error) in
        if let response = response, response.statusCode == 200 || response.statusCode == 201 {
          completion(nil)
        } else if let error = error {
          completion(self.getVAError(from: error))
        } else {
          completion(.Unknown)
        }
      }
    } else {
      completion(.Failure("Não foi possível recuperar os end points da API."))
    }
  }
}
