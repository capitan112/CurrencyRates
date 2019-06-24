//
//  CurrencyRatesRouter.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 23/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation
import UIKit

protocol CurrencyRatesRouterProtocol: class {
  func routeToFromCurrencyViewController(source: UIViewController)
}

class CurrencyRatesRouter: CurrencyRatesRouterProtocol {
  func routeToFromCurrencyViewController(source: UIViewController) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let destinationVC = storyboard.instantiateViewController(withIdentifier: String(describing: FromCurrencyViewController.self)) as! FromCurrencyViewController
    navigateToDetailVC(source: source, destination: destinationVC)
  }

  fileprivate func navigateToDetailVC(source: UIViewController, destination: FromCurrencyViewController) {
    source.present(destination, animated: true, completion: nil)
  }
}
