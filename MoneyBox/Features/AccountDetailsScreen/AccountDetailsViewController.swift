//
//  AccountDetailsViewController.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//


import UIKit

class AccountDetailsViewController: UIViewController {
    
    var accountDetailsViewModel: AccountDetailsViewModel?
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountNameType: UILabel!
    @IBOutlet weak var accountPlanValue: UILabel!
    @IBOutlet weak var accountContributions: UILabel!
    
    @IBOutlet weak var accountContributionPercentageLabel: UILabel!
    @IBOutlet weak var accountContributionsProgressContainer: UIView!
    @IBOutlet weak var accountContributionsFiller: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyViewModel()
        showElements()
    }
    
    private func applyViewModel( ){
        accountNameLabel.text = accountDetailsViewModel?.accountName
        accountNameType.text = accountDetailsViewModel?.accountType
        accountPlanValue.text = "Plan Value: \(accountDetailsViewModel?.planValue.toPoundSterlingString() ?? "")"
        accountContributions.text = "Contributions: \(accountDetailsViewModel?.contributions.toPoundSterlingString() ?? "")"
    }
    
    private func showElements() {
        
        accountContributionsProgressContainer.layer.borderColor = UIColor.accentColor?.cgColor
        accountContributionsProgressContainer.layer.borderWidth = 1
        
        UIView.animate(withDuration: 0.3) {
            self.accountNameLabel.alpha = 1
            self.accountNameType.alpha = 1
            self.accountPlanValue.alpha = 1
            self.accountContributions.alpha = 1
        } completion: { _ in
//            self.showPotProgress()
        }
    }
    
    private func showPotProgress() {
        
        let heightAnchor = [ accountContributionsFiller.heightAnchor.constraint(equalTo: accountContributionsProgressContainer.heightAnchor, multiplier: accountDetailsViewModel?.potProgress() ?? 0)
                             ]
        NSLayoutConstraint.activate(heightAnchor)
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            let progress = Int((self.accountDetailsViewModel?.potProgress() ?? 0) * 100)
            self.accountContributionPercentageLabel.text = "\(progress)%"
            UIView.animate(withDuration: 0.3) {
                self.accountContributionPercentageLabel.alpha = 1
            }
        }
    }
}
