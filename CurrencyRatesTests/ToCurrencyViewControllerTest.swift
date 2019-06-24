//
//  ToCurrencyViewControllerTest.swift
//  CurrencyRatesTests
//
//  Created by Oleksiy Chebotarov on 19/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import XCTest
@testable import CurrencyRates

class ToCurrencyViewControllerTest: XCTestCase {

    var sut: ToCurrencyViewController!
    var spy: ToCurrencyPresenterSpy!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        spy = ToCurrencyPresenterSpy()
        setupProductTableViewController()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        spy = nil
        window = nil
    }
    
    // MARK: Test setup
    
    func setupProductTableViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: String (describing: ToCurrencyViewController.self)) as? ToCurrencyViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    class ToCurrencyPresenterSpy: ToCurrencyPresenterProtocol, ToCurrencyDataStore {
        var viewController: ToCurrencyDisplayLogic?
        var storedService: StoredServiceProtocol?
        var currencyPairs: [(CurrencyInfo, isSelected: Bool)]?
        var fromCurrency: CurrencyInfo?
        var toCurrency: CurrencyInfo?
        var isLoadCurrencyPairs = false
        var isSavedSelectedCurrency = false
        
        func loadCurrencyPairs() {
            currencyPairs = [(CurrencyInfo, isSelected: Bool)]()
            let currency = CurrencyInfo(imageName: "UK", currencyCode: "GBP", description: "Great Britain Pound", shortDescription: "GB pound")
            currencyPairs?.append((currency, false))
            
            isLoadCurrencyPairs = true
        }
        
        func saveSelectedCurrency(toCurrency: CurrencyInfo) {
            isSavedSelectedCurrency = true
        }
    }

    // MARK: Tests

    func testShouldLoadCurrencyRatesWhenCallLoadingCurrencyRates() {
        sut.toCurrencyPresenter = spy
        loadView()
        XCTAssertTrue(spy.isLoadCurrencyPairs, "viewDidLoad() controller should ask the presenter to currency rates")
    }
    
    func testShouldSaveCurrencyRatesWhenCallDidSelectRow() {
        sut.toCurrencyPresenter = spy
        loadView()
    
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)

        XCTAssertTrue(spy.isSavedSelectedCurrency, "didSelectRowAt indexPath controller should ask the presenter to save rates")
    }
}
