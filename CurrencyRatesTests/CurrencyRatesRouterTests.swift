//
//  CurrencyRatesRouterTests.swift
//  CurrencyRatesTests
//
//  Created by Oleksiy Chebotarov on 19/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import XCTest
@testable import CurrencyRates

class CurrencyRatesRouterTests: XCTestCase {
    var sut: CurrencyRatesViewController!
    var spy: CurrencyRatesRouterSpy!
    var window: UIWindow!

    override func setUp() {
        super.setUp()
        window = UIWindow()
        spy = CurrencyRatesRouterSpy()
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
    
    class CurrencyRatesRouterSpy: CurrencyRatesRouterProtocol {
        var isRouteToVC = false
        
        func routeToFromCurrencyViewController(source _: UIViewController) {
            isRouteToVC = true
        }
    }

    func testShouldRouteToViewControllerWhenCallRouteToFromCurrency() {
        sut.router = spy
        loadView()
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        XCTAssertTrue(spy.isRouteToVC, "didSelect in TableView should ask the presenter to route")
    }

}
