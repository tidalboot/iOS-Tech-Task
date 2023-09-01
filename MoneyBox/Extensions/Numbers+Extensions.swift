//
//  Numbers+Extensions.swift
//  MoneyBox
//
//  Created by Nick Jones on 01/09/2023.
//

import Foundation

extension Double {
    func toPoundSterlingString() -> String {
        "£\(self)"
    }
}

extension Int {
    func toPoundSterlingString() -> String {
        "£\(self)"
    }
}
