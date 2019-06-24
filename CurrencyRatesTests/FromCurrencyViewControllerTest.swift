//
//  FromCurrencyViewControllerTest.swift
//  CurrencyRatesTests
//
//  Created by Oleksiy Chebotarov on 19/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import XCTest
@testable import CurrencyRates

class FromCurrencyViewControllerTest: XCTestCase {

    var sut: FromCurrencyViewController!
    var spy: FromCurrencyPresenterSpy!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        spy = FromCurrencyPresenterSpy()
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
        sut = storyboard.instantiateViewController(withIdentifier: String (describing: FromCurrencyViewController.self)) as? FromCurrencyViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }


    class FromCurrencyPresenterSpy: FromCurrencyPresenterProtocol, FromCurrencyDataStore  {
        var viewController: FromCurrencyDisplayLogic?
        var currencyCells: [CurrencyInfo]?
        var isPopulateCurrency = false
        
        func loadCurrencyPairs() {
            currencyCells = [CurrencyInfo]()
            let currency = CurrencyInfo(imageName: "UK", currencyCode: "GBP", description: "Great Britain Pound", shortDescription: "GB pound")
            currencyCells?.append(currency)
            
            isPopulateCurrency = true
        }
    }
    
    // MARK: Tests
    
    func testShouldDoLoadCurrencyRatesWhenCallLoadingCurrencyRates() {
        sut.fromCurrencyPresenter = spy
        loadView()
        XCTAssertTrue(spy.isPopulateCurrency, "loadCurrencyPairs() should ask the presenter to currency rates")
    }
}
