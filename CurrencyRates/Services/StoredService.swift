//
//  StoredService.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 20/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation

protocol StoredServiceProtocol {
  init(storageKey: String)
  func saveCurency(pairRates: CurrencyPair)
  func fetchPairRates() -> [CurrencyPair]?
  func removeObjectsByKey()
  func removePairRates(pairRates: CurrencyPair) -> [CurrencyPair]?
  func isAddedNewCurrencyPair() -> Bool
  func currencyPairDidAdded()
  func discardCurrencyPairAdded()
}

let storageKey = "currencyPairKey"

class StoredService: StoredServiceProtocol {
  fileprivate let storageKey: String!
  fileprivate let isAddedNewPairKey: String = "isAddedNewPair"

  required init(storageKey: String) {
    self.storageKey = storageKey
    discardCurrencyPairAdded()
  }

  func saveCurency(pairRates: CurrencyPair) {
    if pairRates.fromCurrency == pairRates.toCurrency {
      return
    }

    var pairRatesArray = [CurrencyPair]()

    if isKeyPresentInUserDefaults() {
      if let savedRatesData = UserDefaults.standard.data(forKey: storageKey),
        let savedRates = try? JSONDecoder().decode([CurrencyPair].self, from: savedRatesData) {
        pairRatesArray = savedRates
      }
    }

    if !pairRatesArray.contains(pairRates) {
      pairRatesArray.insert(pairRates, at: 0)

      if let encoded = try? JSONEncoder().encode(pairRatesArray) {
        UserDefaults.standard.set(encoded, forKey: storageKey)
        currencyPairDidAdded()
      }
    }
  }

  fileprivate func isKeyPresentInUserDefaults() -> Bool {
    return UserDefaults.standard.object(forKey: storageKey) != nil
  }

  func removeObjectsByKey() {
    if isKeyPresentInUserDefaults() {
      UserDefaults.standard.removeObject(forKey: storageKey)
    }
  }

  func fetchPairRates() -> [CurrencyPair]? {
    if let savedRatesData = UserDefaults.standard.data(forKey: storageKey),
      let savedRates = try? JSONDecoder().decode([CurrencyPair].self, from: savedRatesData) {
      return savedRates
    }

    return nil
  }

  func removePairRates(pairRates: CurrencyPair) -> [CurrencyPair]? {
    if let savedRatesData = UserDefaults.standard.data(forKey: storageKey),
      var savedRates = try? JSONDecoder().decode([CurrencyPair].self, from: savedRatesData) {
      if let index = savedRates.firstIndex(of: pairRates) {
        savedRates.remove(at: index)
      }

      if let encoded = try? JSONEncoder().encode(savedRates) {
        UserDefaults.standard.set(encoded, forKey: storageKey)
      }

      return savedRates
    }

    return nil
  }

  // MARK: - new currency pair

  func isAddedNewCurrencyPair() -> Bool {
    return UserDefaults.standard.bool(forKey: isAddedNewPairKey)
  }

  func currencyPairDidAdded() {
    UserDefaults.standard.set(true, forKey: isAddedNewPairKey)
  }

  func discardCurrencyPairAdded() {
    UserDefaults.standard.set(false, forKey: isAddedNewPairKey)
  }
}
