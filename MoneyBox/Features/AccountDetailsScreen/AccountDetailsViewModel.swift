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
    let contributions: Int
    
    init(accountName: String, accountType: String, planValue: Double, contributions: Int) {
        self.accountName = accountName
        self.accountType = accountType
        self.planValue = planValue
        self.contributions = contributions
    }
    
    func potProgress() -> Double {
        Double(contributions) / planValue
    }
}
