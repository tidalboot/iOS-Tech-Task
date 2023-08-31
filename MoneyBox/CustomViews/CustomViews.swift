//
//  CustomViews.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import UIKit

class RoundView:UIView {
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.bounds.width/2
        self.layer.masksToBounds = true
    }
}
