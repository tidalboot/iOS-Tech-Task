//
//  AccountsViewModel.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import Networking

struct AccountInformation {
    let name: String
    let value: Double
    let contributions: Int
}

class AccountsViewModel {
    let username: String
    var totalPlanValue: Double?
    var accounts: [AccountInformation] = []
    
    init(username: String) {
        self.username = username
    }
    
    func loadAccountDetails(withCompletion completion: @escaping (_ success: Bool) -> Void) {
        SessionHandler.shared.loadAccountDetails { result in
            switch result {
            case .success(let response):
                self.parseAccounts(from: response)
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    private func parseAccounts(from response: AccountResponse) {
        
        totalPlanValue = response.totalPlanValue
        guard let rawAccounts = response.accounts else { return }
        let accounts: [AccountInformation] = rawAccounts.compactMap {
            guard let name = $0.name,
                  let value = $0.wrapper?.totalValue,
                  let contributions = $0.wrapper?.totalContributions else { return nil }
            return AccountInformation(name: name, value: value, contributions: contributions)
        }
        self.accounts = accounts
    }
}
