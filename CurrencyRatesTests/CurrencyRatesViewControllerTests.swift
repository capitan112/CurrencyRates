//
//  CurrencyRatesViewControllerTests.swift
//  CurrencyRatesTests
//
//  Created by Oleksiy Chebotarov on 23/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import XCTest
@testable import CurrencyRates

class CurrencyRatesViewControllerTests: XCTestCase {
    var sut: CurrencyRatesViewController!
    var spy: CurrencyRatesPresenterSpy!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        spy = CurrencyRatesPresenterSpy()
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
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: CurrencyRatesViewController.self)) as? CurrencyRatesViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    class CurrencyRatesPresenterSpy: CurrencyRatesPresenterProtocol, CurrencyRatesDataStore {
        weak var viewController: CurrencyRatesDisplayLogic?
        var networkService: NetworkServiceProtocol?
        var storedService: StoredServiceProtocol?
        var urlConfigService: URLConfigServiceProtocol?
        var currencyPairs: [(CurrencyInfo, CurrencyInfo)]?
        var isTimerRun = false
        var isTimerStop = false
        var isRouteToVC = false
        var isLoadCurrency = false
        var isRemoveRate = false
        var isConfigURL = false
        
        func runTimer() {
            isTimerRun = true
        }
        
        func stopTimer() {
            isTimerStop = true
        }
        
        func routeToFromCurrencyViewController(source _: UIViewController) {
            isRouteToVC = true
        }
        
        func loadCurrencyRates() {
            isLoadCurrency = true
        }
        
        func removeRatePair(at _: Int) {
            isRemoveRate = true
        }
        
        func configURL(curencyPair _: (CurrencyInfo, CurrencyInfo)) -> (url: String, pair: String)? {
            isConfigURL = true
            
            return nil
        }
    }
    
    // MARK: Tests
    
    func testShouldLoadCurrencyRatesWhenCallLoadingCurrencyRates() {
        sut.currencyPresenter = spy
        loadView()
        XCTAssertTrue(spy.isLoadCurrency, "viewDidLoad() controller should ask the presenter to currency rates")
    }
    
    func testShouldRunTimerAfterDidAppear() {
        sut.currencyPresenter = spy
        loadView()
        sut.tableView.isHidden = false
        sut.viewDidAppear(false)
        XCTAssertTrue(spy.isTimerRun, "runTimer() should ask the presenter to run timer")
    }
    
    func testShouldStopTimerAfterDidDisappear() {
        sut.currencyPresenter = spy
        loadView()
        sut.viewDidDisappear(false)
        XCTAssertTrue(spy.isTimerStop, "runTimer() should ask the presenter to run timer")
    }
}
