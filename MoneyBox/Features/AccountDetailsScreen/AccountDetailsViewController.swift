//
//  AccountDetailsViewController.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//


import UIKit

class AccountDetailsViewController: UIViewController {
    
    var accountDetailsViewModel: AccountDetailsViewModel?
    
    //MARK: - View outlets 🌁
    //Performance outlets
    @IBOutlet weak var accountPerformanceHolder: UIView!
    @IBOutlet weak var performanceLabel: UILabel!
    @IBOutlet weak var performanceDetailsLabel: UILabel!
    //Account details outlets
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountNameTypeTitle: UILabel!
    @IBOutlet weak var accountNameType: UILabel!
    @IBOutlet weak var accountPlanValueTitle: UILabel!
    @IBOutlet weak var accountPlanValue: UILabel!
    //Contribution outlets
    @IBOutlet weak var accountContributionsTitle: UILabel!
    @IBOutlet weak var accountContributions: UILabel!
    //Top up outlets
    @IBOutlet weak var topUpButton: UIButton!
    @IBOutlet weak var topUpLoadingIndicator: UIActivityIndicatorView!
    
    //MARK: - Baked in functions 🍞
    override func viewDidLoad() {
        super.viewDidLoad()
        view.subviews.forEach { $0.alpha = 0 }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyViewModel()
        showElements()
        styleElements()
    }
    
    //MARK: - Styling 💈
    private func styleElements() {
        topUpButton.layer.cornerRadius = 10
    }
    
    //MARK: - Animations 🎭
    private func showElements() {
        
        UIView.animate(withDuration: 0.3) {
            self.accountNameLabel.alpha = 1
            self.accountNameType.alpha = 1
            self.accountNameTypeTitle.alpha = 1
            self.accountPlanValue.alpha = 1
            self.accountPlanValueTitle.alpha = 1
            self.accountContributions.alpha = 1
            self.accountContributionsTitle.alpha = 1
        } completion: { _ in
            self.showPerformanceDetails()
        }
    }
    
    //MARK: - State setters 🔨
    private func applyViewModel( ){
        accountNameLabel.text = accountDetailsViewModel?.accountName
        accountNameType.text = accountDetailsViewModel?.accountType
        accountPlanValue.text =  accountDetailsViewModel?.planValue.toPoundSterlingString()
        accountContributions.text = accountDetailsViewModel?.moneybox.toPoundSterlingString()
    }
    
    private func showPerformanceDetails() {
        guard let earnings = accountDetailsViewModel?.earnings else { return }
        
        updatePerformanceLabel(withEarnings: earnings)
        updatePerformanceDetailsLabel(withEarnings: earnings)
        UIView.animate(withDuration: 0.3) {
            self.accountPerformanceHolder.alpha = 1
        }
    }
    
    private func updatePerformanceDetailsLabel(withEarnings earnings: Double) {
        let textToUse: String = {
            guard earnings != 0 else {
                return "Looking good, the value of your account is holding steady"
            }
            return earnings < 0 ? "The value of your account is currently lower than the amount you've contributed.\nRemember that if you're feeling uncertain or concerned about your investment you can always reach out to us" : "Geat news, the value of your account is higher than what you've contributed!"
        }()
        performanceDetailsLabel.text = textToUse
    }
    
    private func updatePerformanceLabel(withEarnings earnings: Double) {
        performanceLabel.textColor = earnings < 0 ? .negativeRed : .positiveGreen
        performanceLabel.text = earnings.toPoundSterlingString()
    }
    
    private func startLoadingState() {
        topUpLoadingIndicator.alpha = 1
        topUpButton.setTitle("", for: .normal)
        navigationController?.navigationBar.backItem?.backBarButtonItem?.isEnabled = false
    }
    
    private func stopLoadingState() {
        topUpLoadingIndicator.alpha = 0
        topUpButton.setTitle("Add £10", for: .normal)
        navigationController?.navigationBar.backItem?.backBarButtonItem?.isEnabled = true
    }
    
    private func reloadMoneyBoxAmount() {
        UIView.animate(withDuration: 0.3) {
            self.accountContributions.alpha = 0
        } completion: { _ in
            self.accountContributions.text = self.accountDetailsViewModel?.moneybox.toPoundSterlingString()
            UIView.animate(withDuration: 0.3) {
                self.accountContributions.alpha = 1
            }
        }
    }
    
    //MARK: - Button Delegate Handlers 🔘
    @IBAction func tappedTopUpButton() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        startLoadingState()
        
        accountDetailsViewModel?.topUpAccount(withCompletion: { success in
            self.stopLoadingState()
            
            guard success else {
                self.showGenericErrorAlert()
                return
            }
            
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.reloadMoneyBoxAmount()
        })
    }
}
