import Foundation
@testable import Appub

class TestHelper {
    
    static func jsonData() -> Data {
        let fileName = "beer"
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch let error {
                fatalError(error.localizedDescription)
            }
        }
        fatalError("Could not read beer.json file")
    }
  
  static func createBeerList() -> [Beer] {
    return [Beer(id: 5,
                 name: "Avery Brown Dredge",
                 tagline: "Bloggers' Imperial Pilsner.",
                 description: "An Imperial Pilsner in collaboration with beer writers. Tradition. Homage." +
                  " Revolution. We wanted to showcase the awesome backbone of the Czech brewing tradition," +
                  " the noble Saaz hop, and also tip our hats to the modern beers that rock our world, " +
      "and the people who make them.",
                 imageURL: "https://images.punkapi.com/v2/5.png",
                 abv: 7.2,
                 ibu: 59.0)]
  }
}
