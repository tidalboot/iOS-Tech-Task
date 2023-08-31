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
            self.usernameLabelTopSpace.constant = 10
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
    
    private func loadAccountDetails() {
        
    }
}

extension AccountsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCell", for: indexPath)
            as? AccountCollectionViewCell
            else { fatalError("Could not find account cell") }
        cell.planNameLabel.text = "foo"
        cell.planValueLabel.text = "\(Int.random(in: 1...3))"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}

extension AccountsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 300)
    }
}
