import Foundation

class HTTPRequestsWorker {
  
  /// Performs a GET operation at the specified url and returns a JSON.
  ///
  /// - Parameters:
  ///   - url: Url to be visited.
  ///   - completion: The completion handler to call when the load request is complete.
  public func getHTTP<T : Decodable>(at url: String, withCompletion completion: @escaping (T?, ServiceError?) -> Void) {
    guard let url = URL(string: url) else {
      completion(nil, .CouldNotFoundURL)
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print(error.localizedDescription)
        completion(nil, .Failure(error.localizedDescription))
      } else if let data = data {
        do {
          let jsonDecoder = JSONDecoder()
          let obj = try jsonDecoder.decode(T.self, from: data)
          
          completion(obj, nil)
        }
        catch let error {
          completion(nil, .Unknown(error.localizedDescription))
        }
      } else {
        completion(nil, .CouldNotParseResponse)
      }
      }.resume()
  }
  
  /// Performs a GET operation at the specified url and returns raw Data.
  ///
  /// - Parameters:
  ///   - url: Url to be visited.
  ///   - completion: The completion handler to call when the load request is complete.
  public func getHTTP(at url: String, withCompletion completion: @escaping (Data?, ServiceError?) -> Void) {
    guard let url = URL(string: url) else {
      completion(nil, .CouldNotFoundURL)
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print(error.localizedDescription)
        completion(nil, .Failure(error.localizedDescription))
      } else if let data = data {
        completion(data, nil)
      } else {
        completion(nil, .CouldNotParseResponse)
      }
      }.resume()
  }
}
