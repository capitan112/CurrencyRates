//
//  FromCurrencyViewController.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 19/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import UIKit

protocol ToCurrencyDisplayLogic: class {
  func reloadTableView()
}

class ToCurrencyViewController: UITableViewController, ToCurrencyDisplayLogic {
  let tableViewCellHeight: CGFloat = 56
  let tableViewTopInset: CGFloat = 30.0
  let cellAlpha: CGFloat = 0.4
  let toCurrencyCellID = "ToCurrencyCellID"
  var toCurrencyPresenter: (ToCurrencyPresenterProtocol & ToCurrencyDataStore)?

  // MARK: Object lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func reloadTableView() {
    performUIUpdatesOnMain {
      self.tableView.reloadData()
    }
  }

  // MARK: Setup

  private func setup() {
    let viewController = self
    toCurrencyPresenter = ToCurrencyPresenter()
    toCurrencyPresenter?.viewController = viewController
    toCurrencyPresenter?.storedService = StoredService(storageKey: storageKey)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    toCurrencyPresenter?.loadCurrencyPairs()
    tableView.contentInset.top = tableViewTopInset
  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell!
    cell = tableView.dequeueReusableCell(withIdentifier: toCurrencyCellID, for: indexPath) as! CurrencyTableViewCell
    if let currency = toCurrencyPresenter?.currencyPairs?[indexPath.row] {
      (cell as! CurrencyTableViewCell).config(currencyInfo: currency.0)

      if currency.isSelected {
        cell.contentView.alpha = cellAlpha
        cell.isUserInteractionEnabled = currency.isSelected
      }
    }
    return cell
  }

  override func numberOfSections(in _: UITableView) -> Int {
    return 1
  }

  override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return tableViewCellHeight
  }

  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return toCurrencyPresenter?.currencyPairs?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    if let selectedCurrency = toCurrencyPresenter?.currencyPairs?[indexPath.row] {
      toCurrencyPresenter?.saveSelectedCurrency(toCurrency: selectedCurrency.0)
    }

    view.window!.rootViewController?.dismiss(animated: false, completion: nil)
  }
}
