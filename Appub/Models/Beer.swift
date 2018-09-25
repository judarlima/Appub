import Foundation

struct Beer {
  let id: Int
  let name, tagline, description: String
  let imageURL: String
  let abv: Double
  let ibu: Double?
}

extension Beer: Decodable {
  enum CodingKeys: String, CodingKey {
    case id, name, tagline
    case description
    case imageURL = "image_url"
    case abv
    case ibu
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try values.decode(Int.self, forKey: .id)
    name = try values.decode(String.self, forKey: .name)
    tagline = try values.decode(String.self, forKey: .tagline)
    description = try values.decode(String.self, forKey: .description)
    imageURL = try values.decode(String.self, forKey: .imageURL)
    abv = try values.decode(Double.self, forKey: .abv)
    ibu = try values.decode(Double?.self, forKey: .ibu)
  }
}
