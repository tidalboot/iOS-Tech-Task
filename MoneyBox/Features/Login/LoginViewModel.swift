//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import Networking


class LoginViewModel {
    
    func handleLogin(withEmail email: String, password: String, andCompletion completion: @escaping (_ succcess: Bool) -> Void) {
        let dataProvider = DataProvider()
        let loginRequest = LoginRequest(email: email, password: password)
        dataProvider.login(request: loginRequest) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
