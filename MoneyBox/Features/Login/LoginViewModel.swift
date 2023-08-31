//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import Networking

struct AccountDetails: Decodable {
    let firstName: String
    let totalMoneyBoxAmount: Double
}

class LoginViewModel {
    
    private let testing = true
    private let testUsername = "test+ios2@moneyboxapp.com"
    private let testPassword = "P455word12"
    
    func handleLogin(withEmail email: String, password: String, andCompletion completion: @escaping (_ customerName: String?, _ succcess: Bool) -> Void) {
        let dataProvider = DataProvider()
        let loginRequest = LoginRequest(
            email: testing ? testUsername : email,
            password: testing ? testPassword : password)
        dataProvider.login(request: loginRequest) { result in
            switch result {
            case .success(let response):
                completion(response.user.firstName, true)
            case .failure(_):
                completion(nil, false)
            }
        }
    }
}
