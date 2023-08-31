//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    
    //MARK: - View outlets 🌁
    @IBOutlet weak var moneyboxLogoImageView: UIImageView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var informationalLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //MARK: - Constraint outlets 🪢
    @IBOutlet weak var moneyBoxLogoImageViewYCenter: NSLayoutConstraint!
    @IBOutlet weak var moneyBoxLogoImageViewTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var emailAddressTextFieldTopSpacing: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        styleElements()
        animateLogoOut()
    }
    
    
    //MARK: - Styling 💈
    private func styleElements() {
        loginButton.layer.cornerRadius = 10
    }
    
    private func setDefaultLoginButtonState() {
        loginButton.setTitle("Login", for: .normal)
        loadingIndicator.alpha = 0
    }
    
    private func setLoadingLoginButtonState() {
        loginButton.setTitle("", for: .normal)
        loadingIndicator.alpha = 1
    }
    
    //MARK: - Navigation Handlers ⛴️
    private func goToAccountScreen(forUser username: String) {
        
        guard let accountViewController = UIStoryboard.init(name: "Accounts", bundle: Bundle.main).instantiateViewController(withIdentifier: "AccountsVC") as? AccountsViewController else { return }
        accountViewController.viewModel = AccountsViewModel(username: username)
        navigationController?.setViewControllers([accountViewController], animated: false)
    }
    
    //MARK: - Logic Handlers 🤖
    
    private func checkForBothFieldsBeingFilled() -> Bool {
        emailAddressTextField.text != nil &&
        passwordTextField.text != nil &&
        !(emailAddressTextField.text ?? "").isEmpty &&
        !(passwordTextField.text ?? "").isEmpty
    }
    
    private func handleLogin() {
        if let emailEnterred = emailAddressTextField.text,
           let passwordEnterred = passwordTextField.text, checkForBothFieldsBeingFilled() {
            continueLogin(withEmail: emailEnterred, andPassword: passwordEnterred)
            return
        }
            
        if emailAddressTextField.text?.isEmpty ?? false {
            showEmailError()
        }
        
        if passwordTextField.text?.isEmpty ?? false {
            showPasswordError()
        }
    }
    
    private func continueLogin(withEmail email: String, andPassword password: String) {
        
        setLoadingLoginButtonState()
        
        loginViewModel.handleLogin(withEmail: email, password: password) { username, succcess in
            guard succcess, let username = username else {
                self.setDefaultLoginButtonState()
                self.showGenericLoginError()
                return
            }
            
            self.animateOutAllElements {
                self.goToAccountScreen(forUser: username)
            }
        }
    }
    
    func animateOutAllElements(withCompletion completion: @escaping () -> Void) {
        
        UIView.animate(withDuration: 0.4, delay: 0.5) {
            self.moneyboxLogoImageView.alpha = 0
            self.emailAddressTextField.alpha = 0
            self.passwordTextField.alpha = 0
            self.loginButton.alpha = 0
            self.loadingIndicator.alpha = 0
        } completion: { _ in
            completion()
        }
    }
    
    //MARK: - Animations 🎭
    private func animateLogoOut() {
        
        /*
         First we slide up the MoneyBox logo that we've placed in the same
         place as the launch screen for a seemless view
        */
        moneyBoxLogoImageViewYCenter.priority = UILayoutPriority(1)
        moneyBoxLogoImageViewTopSpacing.priority = UILayoutPriority(2)
        UIView.animate(withDuration: 0.6, delay: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.animateLogInElementsIn()
        }
    }
    
    private func animateLogInElementsIn() {
        
        /*
         Then we both animate the login text fields in
         and then subsequently show the login button.
         We "slide" the text fields in but not the button
         for a nicer animation
        */
        emailAddressTextFieldTopSpacing.constant = 40
        
        UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 5, initialSpringVelocity: 20) {
            self.view.layoutIfNeeded()
            self.emailAddressTextField.alpha = 1
            self.passwordTextField.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.loginButton.alpha = 0.3
            }
        }
    }
    
    private func enableLoginButton() {
        UIView.animate(withDuration: 0.3) {
            self.loginButton.alpha = 1
        } completion: { _ in
            self.loginButton.isEnabled = true
        }
    }
    
    private func showEmailError() {
        emailAddressTextField.textColor = .systemRed
        showGenericLoginError()
    }
    
    private func showPasswordError() {
        passwordTextField.textColor = .systemRed
        showGenericLoginError()
    }
    
    private func showGenericLoginError() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        informationalLabel.text = "Invalid email address or password please try again"
        informationalLabel.textColor = .systemRed
    }
    
    private func hideGenericLoginError() {
        guard informationalLabel.text != "" else { return }
        UIView.animate(withDuration: 0.3) {
            self.informationalLabel.alpha = 0
        } completion: { _ in
            self.informationalLabel.text = ""
        }

        informationalLabel.textColor = .systemRed
    }
    
    //MARK: - Button Delegate Handlers 🔘
    @IBAction func tappedLogin(_ sender: Any) {
        handleLogin()
    }
    
    //MARK: - Text Field Delegate Handlers ✏️
    @IBAction func userStartedEditingField(_ sender: UITextField) {
        sender.textColor = .accentColor
        setDefaultLoginButtonState()
        hideGenericLoginError()
        
        guard checkForBothFieldsBeingFilled() else { return }
        enableLoginButton()
    }
    
    @IBAction func userTappedNext(_ sender: UITextField) {
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func userTappedGo(_ sender: UITextField) {
        passwordTextField.resignFirstResponder()
        handleLogin()
    }
}
