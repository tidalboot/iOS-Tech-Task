//
//  AccountsViewController.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import UIKit

class AccountsViewController: UIViewController {
    
    var viewModel: AccountsViewModel?
    
    @IBOutlet weak var usernameLabelTopSpace: NSLayoutConstraint!
    
    @IBOutlet weak var accountsCollectionView: UICollectionView!
    @IBOutlet weak var accountsLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var planValueHeaderLabel: UILabel!
    @IBOutlet weak var planValueLabel: UILabel!
    
    @IBOutlet weak var planValueLoadingIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpInitialElements()
        animateElementsIn {
            self.loadAccountDetails()
        }
    }
    
    private func setUpInitialElements() {
        guard let username = viewModel?.username else { return }
        usernameLabel.text = "Welcome back \(username)!"
    }
    
    private func animateElementsIn(withCompletion completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3) {
            self.accountsLabel.alpha = 1
        } completion: { _ in
            self.usernameLabelTopSpace.constant = 20
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.usernameLabel.alpha = 1
                self.planValueHeaderLabel.alpha = 1
            } completion: { _ in
                self.planValueLoadingIndicator.alpha = 1
                completion()
            }
        }
    }
    
    private func refreshTotalValueLabel() {
        UIView.animate(withDuration: 0.3) {
            self.planValueLoadingIndicator.alpha = 0
        } completion: { _ in
            /*
             Here we'll simply display pound sterling because
             we're only available in the UK
             We can add additional safeguards later so we can dynamically
             change or load the currency but doing so also requires us
             to handle the different currency formatting systems such as
             €12,12 or €12 000 so for now we'll simply make this basic assumption
             */
            self.planValueLabel.text = "£\(self.viewModel?.totalPlanValue ?? 0)"
            UIView.animate(withDuration: 0.3) {
                self.planValueLabel.alpha = 1
            }
        }
    }
    
    private func loadAccountDetails() {
        viewModel?.loadAccountDetails(withCompletion: { success in
            guard success else {
//                showError()
                return
            }
            
            self.refreshTotalValueLabel()
            self.accountsCollectionView.reloadData()
            UIView.animate(withDuration: 0.4) {
                self.accountsCollectionView.alpha = 1
            }
        })
    }
}

extension AccountsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCell", for: indexPath)
            as? AccountCollectionViewCell
            else { fatalError("Could not find account cell") }
        cell.alpha = 0
        guard let model = viewModel else { return cell }
        guard !model.accounts.isEmpty else { return cell }
        
        cell.planNameLabel.text = model.accounts[indexPath.row].name
        /*
         Here we'll simply display pound sterling because
         we're only available in the UK
         We can add additional safeguards later so we can dynamically
         change or load the currency but doing so also requires us
         to handle the different currency formatting systems such as
         €12,12 or €12 000 so for now we'll simply make this basic assumption
         */
        cell.planValueLabel.text = "Plan value: £\(model.accounts[indexPath.row].value)"
        cell.alpha = 1
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.accounts.count ?? 0
    }
}

extension AccountsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        CGSize(width: collectionView.frame.size.width, height: 150)
    }
}
