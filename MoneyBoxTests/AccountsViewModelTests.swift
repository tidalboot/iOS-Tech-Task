//
//  AccountInformationTests.swift
//  MoneyBoxTests
//
//  Created by Nick Jones on 01/09/2023.
//

@testable import MoneyBox
import XCTest

final class AccountsViewModelTests: XCTestCase {
    
    let mockedDataProvider = MockedDataProvider()
    
    func testThatAccountsAreLoadedFromValidMockedData() {
        mockedDataProvider.fetchProducts { result in
            guard let response = try? result.get() else {
                XCTFail("no response received from mocked data")
                return
            }
            XCTAssertNotNil(response.accounts, "Unable to load accounts/products from valid mocked data")
        }
    }
    
    func testThatAccountsAreParsedFromValidMockedData() {
        mockedDataProvider.fetchProducts { result in
            guard let response = try? result.get() else {
                XCTFail("no response received from mocked data")
                return
            }
            let accountsViewModel = AccountsViewModel(username: "test")
            let accounts = accountsViewModel.parseAccounts(from: response)
            
            XCTAssertNotNil(accounts.first, "no accounts/products parsed succesfully")
        }
    }
    
    func testThatAccountDetailsAreCorrectlyParsedWhenResponseIsValid() throws {
        mockedDataProvider.fetchProducts { result in
            guard let response = try? result.get() else {
                XCTFail("no response received from mocked data")
                return
            }
            let accountsViewModel = AccountsViewModel(username: "test")
            let accounts = accountsViewModel.parseAccounts(from: response)
            
            guard let firstAccount = accounts.first else {
                XCTFail("no accounts/products found")
                return
            }
            
            XCTAssertEqual(firstAccount.earnings, 1283.09, "invalid earnings")
            XCTAssertEqual(firstAccount.name, "ISA", "invalid name")
            XCTAssertEqual(firstAccount.id, 8043, "invalid id")
            XCTAssertEqual(firstAccount.value, 10526.09, "invalid value")
            XCTAssertEqual(firstAccount.moneybox, 570.00, "invalid moneybox")
        }
    }
}
