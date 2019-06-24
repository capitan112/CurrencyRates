//
//  FromCurrencyRouter.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 23/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation
import UIKit

protocol FromCurrencyRouterProtocol: class {
  func routeToCurrencyViewController(source: UIViewController, selectedCurrency: CurrencyInfo)
}

class FromCurrencyRouter: FromCurrencyRouterProtocol {
  func routeToCurrencyViewController(source: UIViewController, selectedCurrency: CurrencyInfo) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    let destinationVC = storyboard.instantiateViewController(withIdentifier: String(describing: ToCurrencyViewController.self)) as! ToCurrencyViewController
    destinationVC.toCurrencyPresenter?.fromCurrency = selectedCurrency
    navigateToDetailVC(source: source, destination: destinationVC)
  }

  fileprivate func navigateToDetailVC(source: UIViewController, destination: ToCurrencyViewController) {
    source.present(destination, animated: true, completion: nil)
  }
}
