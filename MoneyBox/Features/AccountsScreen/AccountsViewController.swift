//
//  AccountsViewController.swift
//  MoneyBox
//
//  Created by Nick Jones on 31/08/2023.
//

import UIKit

class AccountsViewController: UIViewController {
    
    //MARK: - View model 🧠
    var viewModel: AccountsViewModel?
    
    //MARK: - Constraint outlets 🪢
    @IBOutlet weak var usernameLabelTopSpace: NSLayoutConstraint!
    
    //MARK: - View outlets 🌁
    @IBOutlet weak var accountsCollectionView: UICollectionView!
    @IBOutlet weak var accountsLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var planValueHeaderLabel: UILabel!
    @IBOutlet weak var planValueLabel: UILabel!
    @IBOutlet weak var planValueLoadingIndicator: UIActivityIndicatorView!
    
    //MARK: - Baked in functions 🍞
    override func viewDidLoad() {
        super.viewDidLoad()
        view.subviews.forEach { $0.alpha = 0 }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpInitialElements()
        animateElementsIn {
            self.loadAccounts()
        }
    }
    
    //MARK: - State setters 🔨
    private func setUpInitialElements() {
        guard let firstName = viewModel?.userDetails.firstName else { return }
        usernameLabel.text = "Welcome back \(firstName)!"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(promptLogOut))
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
            self.planValueLabel.text = (self.viewModel?.totalPlanValue ?? 0).toPoundSterlingString()
            UIView.animate(withDuration: 0.3) {
                self.planValueLabel.alpha = 1
            }
        }
    }
    
    //MARK: - Navigation Handlers ⛴️
    private func goToLoginScreen() {
        guard let loginViewController = UIStoryboard.init(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        loginViewController.showLogoutState = true
        self.navigationController?.setViewControllers([loginViewController], animated: false)
    }
    
    private func goToAccountDetailsScreen(forAccount account: AccountInformation) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        guard let accountDetailsViewController = UIStoryboard.init(name: "AccountDetails", bundle: Bundle.main).instantiateViewController(withIdentifier: "AccountDetails") as? AccountDetailsViewController else { return }
        let accountDetailsViewModel = AccountDetailsViewModel(
            accountName: account.name,
            accountType: account.type,
            planValue: account.value,
            moneybox: account.moneybox,
            earnings: account.earnings,
            investorProductId: account.id
        )
        accountDetailsViewController.accountDetailsViewModel = accountDetailsViewModel
        navigationController?.pushViewController(accountDetailsViewController, animated: true)
    }
    
    //MARK: - Interaction handlers 👉
    @objc private func promptLogOut() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            self.logOut()
        }))
        self.present(alert, animated: true)
    }
    
    private func logOut() {
        
        viewModel?.logOut()
        
        UIView.animate(withDuration: 0.3) {
            self.view.subviews.forEach { $0.alpha = 0 }
        } completion: { _ in
            self.goToLoginScreen()
        }
    }
    
    //MARK: - Animations 🎭
    private func animateElementsIn(withCompletion completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3) {
            self.accountsLabel.alpha = 1
        } completion: { _ in
            self.usernameLabelTopSpace.constant = 20
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.usernameLabel.alpha = 1
                self.planValueHeaderLabel.alpha = 1
                self.planValueLabel.alpha = 0
                self.accountsCollectionView.alpha = 0
            } completion: { _ in
                self.planValueLoadingIndicator.alpha = 1
                completion()
            }
        }
    }
    
    //MARK: - Logic Handlers 🤖
    private func loadAccounts() {
        viewModel?.loadAccounts(withCompletion: { success in
            guard success else {
                self.showGenericErrorAlert()
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

extension AccountsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let viewModel = self.viewModel else { return }
        guard indexPath.row <= viewModel.accounts.count - 1 else { return }
        
        let account = viewModel.accounts[indexPath.row]
        goToAccountDetailsScreen(forAccount: account)
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
        
        let account = model.accounts[indexPath.row]
        cell.configureCell(withAccountInformation: account)
        cell.alpha = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.accounts.count ?? 0
    }
}

extension AccountsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        CGSize(width: collectionView.frame.size.width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
