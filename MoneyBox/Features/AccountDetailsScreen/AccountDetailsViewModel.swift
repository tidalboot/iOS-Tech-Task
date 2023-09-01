//
//  AccountDetailsViewModel.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import Foundation

class AccountDetailsViewModel {
    
    let accountName: String
    let accountType: String
    let planValue: Double
    private(set) var moneybox: Double
    let earnings: Double
    
    let investorProductId: Int
    
    init(accountName: String, accountType: String, planValue: Double, moneybox: Double, earnings: Double, investorProductId: Int) {
        self.accountName = accountName
        self.accountType = accountType
        self.planValue = planValue
        self.moneybox = moneybox
        self.earnings = earnings
        self.investorProductId = investorProductId
    }
    
    func topUpAccount(withCompletion completion: @escaping (_ success: Bool) -> Void) {
        
        SessionHandler.shared.topUpAccount(
            forProductId: investorProductId) { result in
                switch result {
                case .success(let response):
                    if let newMoneyBoxValue = response.moneybox {
                        self.moneybox = newMoneyBoxValue
                        completion(true)
                        return
                    }
                    completion(false)
                case .failure(_):
                    completion(false)
                }
            }
    }
}
