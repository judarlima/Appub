//
//  ServiceError.swift
//  Appub
//
//  Created by Judar Lima on 9/22/18.
//  Copyright © 2018 Raduj. All rights reserved.
//

import Foundation

enum ServiceError: Error {
  case CouldNotParseResponse
  case CouldNotFoundURL
  case Failure(String)
  case Unknown(String)
}
