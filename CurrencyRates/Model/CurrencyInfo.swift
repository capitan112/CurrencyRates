//
//  CurrencyInfo.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 20/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation

struct CurrencyInfo: Equatable {
  var imageName: String
  var currencyCode: String
  var description: String
  var shortDescription: String
}

func == (lhs: CurrencyInfo, rhs: CurrencyInfo) -> Bool {
  return lhs.imageName == rhs.imageName &&
    lhs.currencyCode == rhs.currencyCode &&
    lhs.description == rhs.description &&
    lhs.shortDescription == rhs.shortDescription
}
