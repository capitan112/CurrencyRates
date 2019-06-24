//
//  URLConfigService.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 21/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation
import UIKit

protocol URLConfigServiceProtocol {
  func configURL(currencyPair: (CurrencyInfo, CurrencyInfo)) -> (url: String, pair: String)
}

class URLConfigService: URLConfigServiceProtocol {
  func configURL(currencyPair: (CurrencyInfo, CurrencyInfo)) -> (url: String, pair: String) {
    let url = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios?pairs="
    let stringPair = currencyPair.0.currencyCode + currencyPair.1.currencyCode

    return (url + stringPair, stringPair)
  }
}

// it can be for collect url:

// var components = URLComponents()
// components.scheme = Server.APIScheme
// components.host = Server.APIHost
// components.path = Server.path
