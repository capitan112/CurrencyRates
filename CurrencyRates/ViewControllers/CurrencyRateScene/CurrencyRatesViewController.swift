//
//  ViewController.swift
//  CurrencyRates
//
//  Created by Oleksiy Chebotarov on 17/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import UIKit

protocol CurrencyRatesDisplayLogic: class {
  func reloadRowsAtTableView()
  func reloadTableView()
  func reloadTableViewWithInsertRow()
}

enum CurrencySections: Int, CaseIterable {
  case buttonSection
  case currencySection
}

class CurrencyRatesViewController: UIViewController, CurrencyRatesDisplayLogic {
  let buttonCellID = "ButtonCellID"
  let currencyCellID = "CurrencyCellID"
  let tableViewCellHeight: CGFloat = 90

  @IBOutlet var plusImageView: UIImageView!
  @IBOutlet var addCurrencyButton: UIButton!
  @IBOutlet var addCurrencyLabel: UILabel!
  @IBOutlet var tableView: UITableView!

  var currencyPresenter: (CurrencyRatesPresenterProtocol & CurrencyRatesDataStore)?
  var router: CurrencyRatesRouterProtocol?

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
    currencyPresenter = CurrencyRatesPresenter()
    currencyPresenter?.viewController = viewController
    currencyPresenter?.storedService = StoredService(storageKey: storageKey)
    currencyPresenter?.networkService = NetworkService()
    currencyPresenter?.urlConfigService = URLConfigService()
    router = CurrencyRatesRouter()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    config()
  }

  func config() {
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 16)!]
    title = "Rates & converter"
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    currencyPresenter?.loadCurrencyRates()
    tableView.isHidden = (currencyPresenter?.currencyPairs?.count ?? 0 == 0)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !tableView.isHidden {
      currencyPresenter?.runTimer()
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    currencyPresenter?.stopTimer()
  }

  @IBAction func addCurrencyButtonPressed(_: Any) {
    router?.routeToFromCurrencyViewController(source: self)
  }

  func reloadTableView() {
    performUIUpdatesOnMain { [unowned self] in
      UIView.transition(with: self.tableView,
                        duration: 0.7,
                        options: .transitionCrossDissolve,
                        animations: {
                          self.tableView.reloadData()
      })
    }
  }

  func reloadTableViewWithInsertRow() {
    performUIUpdatesOnMain { [unowned self] in
      self.tableView.beginUpdates()
      self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
      self.tableView.endUpdates()
    }
  }

  func reloadRowsAtTableView() {
    performUIUpdatesOnMain { [unowned self] in
      if let cellsArray = self.currencyPresenter?.currencyPairs {
        let lastScrollOffset = self.tableView.contentOffset
        let indexes = (0 ..< cellsArray.count).map { IndexPath(row: $0, section: 1) }
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: indexes, with: .fade)
        self.tableView.endUpdates()
        self.tableView.layer.removeAllAnimations()
        self.tableView.setContentOffset(lastScrollOffset, animated: false)
      }
    }
  }
}

extension CurrencyRatesViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in _: UITableView) -> Int {
    return CurrencySections.allCases.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView.isHidden {
      return 0
    }

    if section == CurrencySections.buttonSection.rawValue {
      return 1
    } else {
      return currencyPresenter?.currencyPairs?.count ?? 0
    }
  }

  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return tableViewCellHeight
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: buttonCellID, for: indexPath) as! AddCurrencyTableViewCell
      cell.layer.cornerRadius = 10
      cell.layer.masksToBounds = true
      cell.descriptionLabel.text = "Add currency pair"
      cell.buttonImageView.image = UIImage(named: "plusImage")

      return cell

    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: currencyCellID, for: indexPath) as! CurrencyPairCell
      if let currencPair = currencyPresenter?.currencyPairs?[indexPath.row] {
        cell.config(currencyPair: currencPair)
        if let pairInfo = currencyPresenter?.configURL(curencyPair: currencPair) {
          currencyPresenter?.networkService?.getRatesBy(url: pairInfo.url, curencyPair: pairInfo.pair, completion: { rate, _ in
            if let rate = rate {
              cell.update(rate: rate)
            }
          })
        }
      }

      return cell
    }
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      tableView.deselectRow(at: indexPath, animated: true)
      currencyPresenter?.stopTimer()
      router?.routeToFromCurrencyViewController(source: self)
    }
  }

  func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section == CurrencySections.buttonSection.rawValue {
      return false
    }

    return true
  }

  func tableView(_: UITableView, willBeginEditingRowAt _: IndexPath) {
    currencyPresenter?.stopTimer()
  }

  func tableView(_: UITableView, didEndEditingRowAt _: IndexPath?) {
    currencyPresenter?.runTimer()
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      currencyPresenter?.removeRatePair(at: indexPath.row)
      tableView.beginUpdates()
      tableView.deleteRows(at: [indexPath], with: .middle)
      tableView.endUpdates()
    }
  }
}
