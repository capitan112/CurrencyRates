//
//  FormCurrencyPresenter.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 20/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation
import UIKit

protocol FromCurrencyPresenterProtocol {
  func loadCurrencyPairs()
  var viewController: FromCurrencyDisplayLogic? { set get }
}

protocol FromCurrencyDataStore {
  var currencyCells: [CurrencyInfo]? { get set }
}

class FromCurrencyPresenter: FromCurrencyPresenterProtocol, FromCurrencyDataStore {
  weak var viewController: FromCurrencyDisplayLogic?
  var currencyCells: [CurrencyInfo]?

  func loadCurrencyPairs() {
    currencyCells = [CurrencyInfo]()

    for country in countries {
      let currency = CurrencyInfo(imageName: country.flag, currencyCode: country.currencyCode, description: country.country, shortDescription: country.shortDesc)
      currencyCells?.append(currency)
    }

    viewController?.reloadTableView()
  }
}
