import Foundation

struct Beer: Codable {
  let id: Int
  let name, tagline, description: String
  let imageURL: String
  let abv: Double
  let ibu: Double?
  
  enum CodingKeys: String, CodingKey {
    case id, name, tagline
    case description
    case imageURL = "image_url"
    case abv
    case ibu
  }
}
