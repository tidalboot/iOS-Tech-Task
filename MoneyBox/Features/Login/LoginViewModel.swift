//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import Networking

class LoginViewModel {
    
    func handleLogin(withEmail email: String, password: String, andCompletion completion: @escaping (_ customerName: String?, _ succcess: Bool) -> Void) {
        
        SessionHandler.shared.logIn(withEmail: email, password: password) { result in
            switch result {
            case .success(let response):
                completion(response.user.firstName, true)
            case .failure(_):
                completion(nil, false)
            }
        }
    }
}
