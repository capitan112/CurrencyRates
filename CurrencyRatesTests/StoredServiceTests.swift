//
//  StoredServiceTests.swift
//  CurrencyRatesTests
//
//  Created by Oleksiy Chebotarov on 19/06/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import XCTest
@testable import CurrencyRates

var sut: StoredService!
var storageKey: String!

class StoredServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        setupNetworkService()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        storageKey = nil
    }
    
    // MARK: Test setup
    
    func setupNetworkService() {
        storageKey = "testKey"
        sut = StoredService(storageKey: storageKey)
    }

    func testSaveCurencyToEmptyStorageShoudlBeSaved() {

        sut.removeObjectsByKey()
    
        let pairRate = CurrencyPair(fromCurrency: "USD", toCurrency: "GBP")
        sut.saveCurency(pairRates: pairRate)

        let savedPairRates = sut.fetchPairRates()
        let sameRates = savedPairRates?[0] == pairRate
        
        XCTAssertTrue(sameRates, "Pair Rartes should be same" )
    }


    func testSaveDublicatedCurencyShoudlNotBeSaved() {

        let pairRate = CurrencyPair(fromCurrency: "USD", toCurrency: "GBP")
        sut.saveCurency(pairRates: pairRate)

        let dublicatedPairRate = CurrencyPair(fromCurrency: "USD", toCurrency: "GBP")
        sut.saveCurency(pairRates: dublicatedPairRate)

        let savedPairRates = sut.fetchPairRates()
        XCTAssertEqual((savedPairRates?.count ?? 0), 1, "Pair Rartes should not be dublicated")
    }


    func testSaveUniqueCurencyShoudlBeSaved() {

        let usdGbpPairRate = CurrencyPair(fromCurrency: "USD", toCurrency: "GBP")
        sut.saveCurency(pairRates: usdGbpPairRate)

        let gbpUsdPairRate = CurrencyPair(fromCurrency: "GBP", toCurrency: "USD")
        sut.saveCurency(pairRates: gbpUsdPairRate)

        let savedPairRates = sut.fetchPairRates()
        XCTAssertEqual((savedPairRates?.count ?? 0), 2, "Pair Rartes should be saved")
    }
    
    
    func testSavePairRateWithSamePropertiesShoudlNotBeSaved() {
        _ = sut.removeObjectsByKey()
        
        let usdGbpPairRate = CurrencyPair(fromCurrency: "USD", toCurrency: "USD")
        sut.saveCurency(pairRates: usdGbpPairRate)
        
        let gbpUsdPairRate = CurrencyPair(fromCurrency: "GBP", toCurrency: "USD")
        sut.saveCurency(pairRates: gbpUsdPairRate)
        
        let savedPairRates = sut.fetchPairRates()
        XCTAssertEqual((savedPairRates?.count ?? 0), 1, "Pair Rates shoud be different")
    }
    
    func testRemoveCurencyPairShoudlBeRemoved() {
        
        let usdGbpPairRate = CurrencyPair(fromCurrency: "USD", toCurrency: "GBP")
        sut.saveCurency(pairRates: usdGbpPairRate)
        
        let gbpUsdPairRate = CurrencyPair(fromCurrency: "GBP", toCurrency: "USD")
        sut.saveCurency(pairRates: gbpUsdPairRate)
        
        var savedPairRates = sut.fetchPairRates()
        XCTAssertEqual((savedPairRates?.count ?? 0), 2, "Pair Rates should be saved")
        
        _ = sut.removePairRates(pairRates: usdGbpPairRate)
        
        savedPairRates = sut.fetchPairRates()
        let sameRates = savedPairRates?[0] == gbpUsdPairRate
        
        XCTAssertTrue(sameRates, "Pair Rartes should be same" )
        XCTAssertEqual((savedPairRates?.count ?? 0), 1, "Pair Rartes should be saved")
    }

}
