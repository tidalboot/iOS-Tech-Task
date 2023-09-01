//
//  MockedDataProvider.swift
//  MoneyBoxTests
//
//  Created by Nick Jones on 01/09/2023.
//

import Networking

class MockedDataProvider: DataProviderLogic {
    
    static let mockLoginRequest = LoginRequest(email: "foo@test.com", password: "barbar123")
    
    func login(request: Networking.LoginRequest, completion: @escaping ((Result<Networking.LoginResponse, Error>) -> Void)) {
        StubData.read(file: "LoginSucceed") { (result: (Result<Networking.LoginResponse, Error>)) in
            completion(result)
        }
    }
    
    func brokenLogin(request: Networking.LoginRequest, completion: @escaping ((Result<Networking.LoginResponse, Error>) -> Void)) {
        StubData.read(file: "BrokenLogin") { (result: (Result<Networking.LoginResponse, Error>)) in
            completion(result)
        }
    }
    
    func fetchProducts(completion: @escaping ((Result<Networking.AccountResponse, Error>) -> Void)) {
        StubData.read(file: "Accounts") { (result: (Result<Networking.AccountResponse, Error>)) in
            completion(result)
        }
    }
    
    func addMoney(request: Networking.OneOffPaymentRequest, completion: @escaping ((Result<Networking.OneOffPaymentResponse, Error>) -> Void)) {
        
    }
}
