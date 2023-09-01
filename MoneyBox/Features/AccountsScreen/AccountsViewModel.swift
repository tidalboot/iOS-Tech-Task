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
    let moneybox: Double
    let type: String
    let earnings: Double
    let id: Int
}

class AccountsViewModel {
    let userDetails: UserDetails
    var totalPlanValue: Double?
    var accounts: [AccountInformation] = []
    
    init(userDetails: UserDetails) {
        self.userDetails = userDetails
    }
    
    func logOut() {
        SessionHandler.shared.logOut()
    }
    
    func loadAccounts(withCompletion completion: @escaping (_ success: Bool) -> Void) {
        SessionHandler.shared.loadAccounts { result in
            switch result {
            case .success(let response):
                let accountInformation = self.parseAccounts(from: response)
                self.accounts = accountInformation
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func parseAccounts(from response: AccountResponse) -> [AccountInformation] {
        
        totalPlanValue = response.totalPlanValue
        
        guard let rawProducts = response.productResponses else { return [] }
        
        let accounts: [AccountInformation] = rawProducts.compactMap {
            guard let name = $0.product?.name,
                  let value = $0.planValue,
                  let type = $0.product?.type,
                  let earnings = $0.investorAccount?.earningsNet,
                  let moneyBox = $0.moneybox,
                  let id = $0.id else { return nil }
            return AccountInformation(name: name, value: value, moneybox: moneyBox, type: type, earnings: earnings, id: id)
        }
        return accounts
    }
}
