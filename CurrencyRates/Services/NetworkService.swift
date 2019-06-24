//
//  NetworkServices.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 19/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
  func getRatesBy(url: String, curencyPair: String, completion: @escaping (_ rate: Double?, _ error: Error?) -> Void)
}

class NetworkService: NetworkServiceProtocol {
  fileprivate let session = URLSession(configuration: .default)

  func getRatesBy(url: String, curencyPair: String, completion: @escaping (_ rate: Double?, _ error: Error?) -> Void) {
    getDataFrom(url: url, completion: { data, error in

      guard let data = data else {
        completion(nil, error)
        return
      }
      do {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let rate = json?[curencyPair] as? Double else {
          let error = NSError(domain: "wrong  json parse", code: 0, userInfo: nil)
          completion(nil, error)
          return
        }
        completion(rate, nil)
      } catch {
        completion(nil, error)
      }
    })
  }

  fileprivate func getDataFrom(url: String, completion: @escaping (_ results: Data?, Error?) -> Void) {
    guard let url = URL(string: url) else {
      let error = NSError(domain: "wrong  searchURL", code: 0, userInfo: nil)
      completion(nil, error)
      return
    }

    let urlRequest = URLRequest(url: url)

    let task = session.dataTask(with: urlRequest, completionHandler: { (data: Data?,
                                                                        response: URLResponse?, error: Error?) in

      if error != nil || data == nil {
        completion(nil, error)
        return
      }

      guard let response = response as? HTTPURLResponse, (200 ... 299).contains(response.statusCode) else {
        completion(nil, error)
        return
      }

      completion(data, nil)
    })

    task.resume()
  }
}
