import Foundation

struct BeerDetailViewModel {
  let imageURL: String
  let name: String
  let tagline: String
  let abv: String
  let ibu: String
  let description: String
  
  init(beer: Beer) {
    self.imageURL = beer.imageURL
    self.name = beer.name
    self.tagline = beer.tagline
    self.abv = String(beer.abv)
    let beerIbu = beer.ibu != nil ? "\(beer.ibu!)" : "N/A"
    self.ibu = beerIbu
    self.description = beer.description
  }
}

