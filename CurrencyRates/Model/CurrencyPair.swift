//
//  PairRates.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 20/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation

struct CurrencyPair: Codable, Equatable {
  var fromCurrency: String
  var toCurrency: String
}

func == (lhs: CurrencyPair, rhs: CurrencyPair) -> Bool {
  return lhs.fromCurrency == rhs.fromCurrency &&
    lhs.toCurrency == rhs.toCurrency
}
