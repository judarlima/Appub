import Foundation

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
}
