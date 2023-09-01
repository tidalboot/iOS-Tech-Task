//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import Networking

struct UserDetails {
    let firstName: String
    let lastName: String
}

class LoginViewModel {
    
    func handleLogin(withEmail email: String, password: String, andCompletion completion: @escaping (_ userDetails: UserDetails?, _ succcess: Bool) -> Void) {
        
        SessionHandler.shared.logIn(withEmail: email, password: password) { result in
            switch result {
            case .success(let response):
                let userDetails = self.parseUserDetails(fromLoginResponse: response)
                completion(userDetails, true)
            case .failure(_):
                completion(nil, false)
            }
        }
    }
    
    func parseUserDetails(fromLoginResponse response: LoginResponse) -> UserDetails? {
        guard let firstName = response.user.firstName, let lastName = response.user.lastName else { return nil }
        return UserDetails(firstName: firstName,
                           lastName: lastName)
    }
}
