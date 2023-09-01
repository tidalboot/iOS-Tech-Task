//
//  Date+Extensions.swift
//  MoneyBox
//
//  Created by Nick Jones on 01/09/2023.
//

import Foundation

extension Date {
    func hasFiveMinutesPassedSinceDate(_ dateToCheck: Date) -> Bool {
        timeIntervalSince(dateToCheck) >= 300
    }
}
