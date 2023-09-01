//
//  NetworkLayer.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import Networking
import Foundation

enum SessionHandlerErrors: Error {
    case Generic
}

class SessionHandler {
    
    private let testing = true
    private let testUsername = "test+ios2@moneyboxapp.com"
    private let testPassword = "P455word12"
    
    static let shared = SessionHandler(dataProvider: DataProvider())
    private let dataProvider: DataProvider
    private var sessionManager: SessionManager
    
    private var storedLoginRequest: LoginRequest?
    private var lastTokenRetrievalTime: Date?
    
    private init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.sessionManager = SessionManager()
    }
    
    //Perfect for testing
    func tokenHasExpired() -> Bool {
        guard let lastTokenRetrievalTime = self.lastTokenRetrievalTime else { return true }
        let timeBetweenNowAndLastToken = Date().timeIntervalSince(lastTokenRetrievalTime)
        return timeBetweenNowAndLastToken > 300
    }
    
    private func checkTokenFreshness(_ completion: @escaping (_ success: Bool) -> Void) {
        guard let storedLoginRequest = storedLoginRequest else {
            completion(false)
            return
        }
        
        guard tokenHasExpired() == false else {
            completion(true)
            return
        }
    
        logIn(withEmail: storedLoginRequest.email,
              password: storedLoginRequest.password) { result in
                switch result {
                case .success(_):
                    completion(true)
                case .failure(_):
                    completion(false)
                }
            }
    }
    
    func logOut() {
        lastTokenRetrievalTime = nil
        storedLoginRequest = nil
        sessionManager = SessionManager()
    }
    
    func logIn(withEmail email: String, password: String, andCompletion completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        
        let loginRequest = LoginRequest(
            email: testing ? testUsername : email,
            password: testing ? testPassword : password)
        
        dataProvider.login(request: loginRequest) { result in
            if let token = try? result.get().session.bearerToken {
                self.sessionManager.setUserToken(token)
                self.storedLoginRequest = loginRequest
                self.lastTokenRetrievalTime = Date()
            }
            
            completion(result)
        }
    }

    func loadAccounts(withCompletion completion: @escaping (_ response: Result<AccountResponse, Error>) -> Void) {
        
        checkTokenFreshness { success in
            guard success else {
                completion(.failure(SessionHandlerErrors.Generic))
                return
            }
            self.dataProvider.fetchProducts { result in
                completion(result)
            }
        }
    }
    
    func topUpAccount(forProductId productId: Int, withCompletion completion: @escaping (_ response: Result<OneOffPaymentResponse, Error>) -> Void) {
        
        checkTokenFreshness { success in
            guard success else {
                completion(.failure(SessionHandlerErrors.Generic))
                return
            }
            
            let oneOffPaymentRequest = OneOffPaymentRequest(amount: 10, investorProductID: productId)
            self.dataProvider.addMoney(request: oneOffPaymentRequest) { result in
                completion(result)
            }
        }
    }
}
