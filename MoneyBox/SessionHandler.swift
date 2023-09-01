//
//  NetworkLayer.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import Networking

class SessionHandler {
    
    private let testing = true
    private let testUsername = "test+ios2@moneyboxapp.com"
    private let testPassword = "P455word12"
    
    static let shared = SessionHandler(dataProvider: DataProvider())
    private let dataProvider: DataProvider
    private let sessionManager: SessionManager
    
    private init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.sessionManager = SessionManager()
    }
    
    func logIn(withEmail email: String, password: String, andCompletion completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        
        let loginRequest = LoginRequest(
            email: testing ? testUsername : email,
            password: testing ? testPassword : password)
        
        dataProvider.login(request: loginRequest) { result in
            if let token = try? result.get().session.bearerToken {
                self.sessionManager.setUserToken(token)
            }
            
            completion(result)
        }
    }
    
    func loadAccounts(withCompletion completion: @escaping (_ response: Result<AccountResponse, Error>) -> Void) {
        
        dataProvider.fetchProducts { result in
            completion(result)
        }
    }
    
    func topUpAccount(forProductId productId: Int, withCompletion completion: @escaping (_ response: Result<OneOffPaymentResponse, Error>) -> Void) {
        let oneOffPaymentRequest = OneOffPaymentRequest(amount: 10, investorProductID: productId)
        dataProvider.addMoney(request: oneOffPaymentRequest) { result in
            completion(result)
        }
    }
}
