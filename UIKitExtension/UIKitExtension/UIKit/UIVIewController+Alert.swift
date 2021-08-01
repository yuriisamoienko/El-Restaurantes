//
//  UIVIewController+Alert.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 28.07.2021.
//

import UIKit
import FoundationExtension

/*
 General way to show alerts without code dublication
 */

public extension UIViewController {
    
    // MARK: Types
    
    class UIAlertMessenger {
        
        // MARK: Private Properties
        
        private let viewController: UIViewController
        
        // MARK: Public Functions
        
        init(viewController: UIViewController) {
            self.viewController = viewController
        }
        
        public func showQuestionAlert(title: String?, message: String?, closeCallback: @escaping (Bool) -> Void) {
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            //TODO translate 'No'
            let noAction = UIAlertAction.init(title: ("No").localized, style: .default) { (_) in
                closeCallback(false)
            }

            //TODO translate 'Yes'
            let yesAction = UIAlertAction.init(title: ("Yes").localized, style: .default) { (_) in
                closeCallback(true)
            }
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            presentAlert(alertController)
        }
        
        public func showAlert(title: String? = nil, message: String? = nil, closeCallback: (() -> Void)? = nil) {
            guard title != nil || message != nil else { return }
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default) { (_) in
                guard let callback = closeCallback else { return }
                callback()
            }
            alertController.addAction(okAction)

            presentAlert(alertController) //, animated: false)
        }
        
        public func showErrorAlert(error: Error, closeCallback: (() -> Void)? = nil) {
            showErrorAlert(message: error.localizedDescription, closeCallback: closeCallback)
        }
        
        public func showErrorAlert(message: String, closeCallback: (() -> Void)? = nil) {
            showAlert(title: .localize.error, message: message, closeCallback: closeCallback)
        }
        
        // MARK: Private Functions
        
        private func presentAlert(_ alert: UIAlertController, animated: Bool = true) {
            viewController.present(viewController: alert, animated: animated)
        }
    }

    // MARK: Public Properties
    
    var alert: UIAlertMessenger {
        UIAlertMessenger(viewController: self)
    }
    
}
