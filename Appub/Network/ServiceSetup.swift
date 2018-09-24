import Foundation

protocol ServiceSetup {
  var endpoint: String { get }
}

struct API {
  struct URL {
    static let base = "https://api.punkapi.com/v2"
  }
}

enum BeersGatewaySetup: ServiceSetup {
  case allBeers
  case singleBeer(id: Int)
  
  var endpoint: String {
    switch self {
    case .allBeers:
      return API.URL.base + "/beers"
    case let .singleBeer(id):
      return API.URL.base + "/beers/\(id)"
    }
  }
}
