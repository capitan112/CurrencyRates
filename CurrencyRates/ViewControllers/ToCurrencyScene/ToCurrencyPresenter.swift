//
//  FormCurrencyPresenter.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 20/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation

protocol ToCurrencyPresenterProtocol {
  func loadCurrencyPairs()
  func saveSelectedCurrency(toCurrency: CurrencyInfo)
  var viewController: ToCurrencyDisplayLogic? { get set }
  var storedService: StoredServiceProtocol? { get set }
}

protocol ToCurrencyDataStore {
  var currencyPairs: [(CurrencyInfo, isSelected: Bool)]? { get set }
  var fromCurrency: CurrencyInfo? { get set }
  var toCurrency: CurrencyInfo? { get set }
}

class ToCurrencyPresenter: ToCurrencyPresenterProtocol, ToCurrencyDataStore {
  weak var viewController: ToCurrencyDisplayLogic?
  var storedService: StoredServiceProtocol?
  var currencyPairs: [(CurrencyInfo, isSelected: Bool)]?
  var fromCurrency: CurrencyInfo?
  var toCurrency: CurrencyInfo?

  func loadCurrencyPairs() {
    currencyPairs = [(CurrencyInfo, isSelected: Bool)]()

    var savedPairSet = Set<String>()
    savedPairSet.insert(fromCurrency!.currencyCode)

    if let savedCurrencyPairs = storedService?.fetchPairRates() {
      for savedCurrencyPair in savedCurrencyPairs {
        if savedCurrencyPair.fromCurrency == fromCurrency!.currencyCode {
          savedPairSet.insert(savedCurrencyPair.toCurrency)
        }
      }
    }

    for country in countries {
      let currency = CurrencyInfo(imageName: country.flag, currencyCode: country.currencyCode, description: country.country, shortDescription: country.shortDesc)

      let isSelected = savedPairSet.contains(country.currencyCode)
      currencyPairs?.append((currency, isSelected))
    }

    viewController?.reloadTableView()
  }

  func saveSelectedCurrency(toCurrency: CurrencyInfo) {
    if let fromCode = fromCurrency {
      let pairRate = CurrencyPair(fromCurrency: fromCode.currencyCode, toCurrency: toCurrency.currencyCode)
      storedService?.saveCurency(pairRates: pairRate)
    }
  }
}
