import Foundation

struct BeerCollectionViewModel {
  let id: String
  let beerImage: String
  let beerNameLabel: String
  let beerAbvLabel: String
  
  init(beer: Beer) {
    self.id = String(beer.id)
    self.beerImage = beer.imageURL
    self.beerNameLabel = beer.name
    self.beerAbvLabel = String(beer.abv)
  }
}

