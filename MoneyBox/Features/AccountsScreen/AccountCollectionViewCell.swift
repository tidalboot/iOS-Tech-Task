//
//  AccountCollectionViewCell.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import UIKit

class AccountCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var planValueLabel: UILabel!
    @IBOutlet weak var planContributionsLabel: UILabel!
    @IBOutlet weak var earningsLabel: UILabel!
    @IBOutlet weak var chevronImage: UIImageView!
    
    func configureCell(withAccountInformation account: AccountInformation) {
        planNameLabel.text = account.name
        /*
         Here we'll simply display pound sterling because
         we're only available in the UK
         We can add additional safeguards later so we can dynamically
         change or load the currency but doing so also requires us
         to handle the different currency formatting systems such as
         €12,12 or €12 000 so for now we'll simply make this basic assumption
         */
        planValueLabel.text = "Plan value: \(account.value.toPoundSterlingString())"
        planContributionsLabel.text = "Moneybox: \(account.moneybox.toPoundSterlingString())"
        earningsLabel.text = "Total earnings: \(account.earnings.toPoundSterlingString())"
        chevronImage.image = chevronImage.image?.withRenderingMode(.alwaysTemplate)
        layer.cornerRadius = 10
    }
}
