//
//  FromCurrencyViewController.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 19/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import UIKit

protocol FromCurrencyDisplayLogic: class {
  func reloadTableView()
}

class FromCurrencyViewController: UITableViewController, FromCurrencyDisplayLogic {
  let tableViewCellHeight: CGFloat = 56
  let tableViewTopInset: CGFloat = 30.0
  let fromCurrencyCellID = "FromCurrencyCellID"
  var fromCurrencyPresenter: (FromCurrencyPresenterProtocol & FromCurrencyDataStore)?
  var router: FromCurrencyRouterProtocol?

  // MARK: Object lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  // MARK: Setup

  private func setup() {
    let viewController = self
    fromCurrencyPresenter = FromCurrencyPresenter()
    fromCurrencyPresenter?.viewController = viewController
    router = FromCurrencyRouter()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    fromCurrencyPresenter?.loadCurrencyPairs()
    tableView.contentInset.top = tableViewTopInset
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }

  // MARK: - Protocol methods

  func reloadTableView() {
    performUIUpdatesOnMain {
      self.tableView.reloadData()
    }
  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell!
    cell = tableView.dequeueReusableCell(withIdentifier: fromCurrencyCellID, for: indexPath) as! CurrencyTableViewCell
    if let currency = fromCurrencyPresenter?.currencyCells?[indexPath.row] {
      (cell as! CurrencyTableViewCell).config(currencyInfo: currency)
    }

    return cell
  }

  override func numberOfSections(in _: UITableView) -> Int {
    return 1
  }

  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return fromCurrencyPresenter?.currencyCells?.count ?? 0
  }

  override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return tableViewCellHeight
  }

  override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let selectedCurrency = fromCurrencyPresenter?.currencyCells?[indexPath.row] {
      router?.routeToCurrencyViewController(source: self, selectedCurrency: selectedCurrency)
    }
  }
}
