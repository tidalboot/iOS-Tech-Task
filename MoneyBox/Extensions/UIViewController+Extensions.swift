//
//  UIViewController+extensions.swift
//  MoneyBox
//
//  Created by Nick Jones on 01/09/2023.
//

import UIKit

extension UIViewController {
    
    func showGenericErrorAlert() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        let dialogMessage = UIAlertController(title: nil, message: "We're sorry but something went wrong", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialogMessage.addAction(ok)
        present(dialogMessage, animated: true)
    }
}
