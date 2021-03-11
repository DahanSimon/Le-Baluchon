//
//  ViewControllerExtension.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 16/02/2021.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}
