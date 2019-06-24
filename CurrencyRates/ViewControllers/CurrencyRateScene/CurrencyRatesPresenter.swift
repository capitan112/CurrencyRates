//
//  CurrencyRatesPresenter.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 19/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation
import UIKit

protocol CurrencyRatesPresenterProtocol {
  func runTimer()
  func stopTimer()
  func loadCurrencyRates()
  func removeRatePair(at: Int)
  func configURL(curencyPair: (CurrencyInfo, CurrencyInfo)) -> (url: String, pair: String)?
  var storedService: StoredServiceProtocol? { get set }
  var networkService: NetworkServiceProtocol? { get set }
  var urlConfigService: URLConfigServiceProtocol? { get set }
  var viewController: CurrencyRatesDisplayLogic? { get set }
}

protocol CurrencyRatesDataStore {
  var currencyPairs: [(CurrencyInfo, CurrencyInfo)]? { get set }
}

class CurrencyRatesPresenter: CurrencyRatesPresenterProtocol, CurrencyRatesDataStore {
  var networkService: NetworkServiceProtocol?
  var storedService: StoredServiceProtocol?
  var currencyPairs: [(CurrencyInfo, CurrencyInfo)]?
  var urlConfigService: URLConfigServiceProtocol?
  weak var viewController: CurrencyRatesDisplayLogic?
  var timer: Timer?

  func loadCurrencyRates() {
    if currencyPairs == nil {
      currencyPairs = [(CurrencyInfo, CurrencyInfo)]()
    }

    if let savedCurrencyPairs = storedService?.fetchPairRates() {
      if currencyPairs?.count != savedCurrencyPairs.count {
        currencyPairs?.removeAll()
        for currencyPair in savedCurrencyPairs {
          var fromCurrency: CurrencyInfo!
          if let leftCurrency = countries.first(where: { $0.currencyCode == currencyPair.fromCurrency }) {
            fromCurrency = CurrencyInfo(imageName: leftCurrency.flag, currencyCode: leftCurrency.currencyCode, description: leftCurrency.country, shortDescription: leftCurrency.shortDesc)
          }
          var toCurrency: CurrencyInfo!
          if let rightCurrency = countries.first(where: { $0.currencyCode == currencyPair.toCurrency }) {
            toCurrency = CurrencyInfo(imageName: rightCurrency.flag, currencyCode: rightCurrency.currencyCode, description: rightCurrency.country, shortDescription: rightCurrency.shortDesc)
          }

          currencyPairs?.append((fromCurrency, toCurrency))
        }
      }
    }

    switch currencyPairs?.count ?? 0 {
    case 0:
      break
    case 1:
      viewController?.reloadTableView()
    default:
      if let isAddedNewCurrency = storedService?.isAddedNewCurrencyPair(), isAddedNewCurrency == true {
        viewController?.reloadTableViewWithInsertRow()
        storedService?.discardCurrencyPairAdded()
      } else {
        viewController?.reloadTableView()
      }
    }
  }

  func removeRatePair(at: Int) {
    if let removedCurrencyPairs = currencyPairs?.remove(at: at) {
      let pairRates = CurrencyPair(fromCurrency: removedCurrencyPairs.0.currencyCode, toCurrency: removedCurrencyPairs.1.currencyCode)
      _ = storedService?.removePairRates(pairRates: pairRates)
    }
  }

  func runTimer() {
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CurrencyRatesPresenter.updateTimer), userInfo: nil, repeats: true)
  }

  @objc func updateTimer() {
    viewController?.reloadRowsAtTableView()
  }

  func stopTimer() {
    timer?.invalidate()
  }

  func getRatesBy(url: String, curencyPair: String, completion: @escaping (_ rate: Double?, _ error: Error?) -> Void) {
    networkService?.getRatesBy(url: url, curencyPair: curencyPair, completion: { rate, error in
      completion(rate, error)
    })
  }

  func configURL(curencyPair: (CurrencyInfo, CurrencyInfo)) -> (url: String, pair: String)? {
    return urlConfigService?.configURL(currencyPair: curencyPair)
  }
}
