//
//  LoginViewModelTests.swift
//  MoneyBoxTests
//
//  Created by Nick Jones on 01/09/2023.
//

@testable import MoneyBox
import XCTest

final class LoginViewModelTests: XCTestCase {
    
    let mockedDataProvider = MockedDataProvider()
    let mockedLoginRequest = MockedDataProvider.mockLoginRequest
    
    func testThatUserDetailsAreLoadedFromValidMockedData() {
        
        mockedDataProvider.login(request: mockedLoginRequest) { result in
            guard let response = try? result.get() else {
                XCTFail("no response received from mocked data")
                return
            }
            XCTAssertNotNil(response.user, "Unable to load user details from valid mocked data")
        }
    }
    
    func testThatUserDetailsAreNotParsedFromInValidMockedData() {
        mockedDataProvider.brokenLogin(request: mockedLoginRequest) { result in
            guard let response = try? result.get() else {
                XCTFail("no response received from mocked data")
                return
            }
            let loginViewModel = LoginViewModel()
            let userDetails = loginViewModel.parseUserDetails(fromLoginResponse: response)
            
            XCTAssertNil(userDetails, "no user details parsed as expected")
        }
    }
    
    func testThatUserDetailsAreCorrectlyParsedWhenResponseIsValid() {
        mockedDataProvider.login(request: mockedLoginRequest) { result in
            guard let response = try? result.get() else {
                XCTFail("no response received from mocked data")
                return
            }
            let loginViewModel = LoginViewModel()
            guard let userDetails = loginViewModel.parseUserDetails(fromLoginResponse: response) else {
                XCTFail("no user details found")
                return
            }
            
            XCTAssertEqual(userDetails.firstName, "Michael", "invalid first name")
            XCTAssertEqual(userDetails.lastName, "Jordan", "invalid last name")
        }
    }
}
