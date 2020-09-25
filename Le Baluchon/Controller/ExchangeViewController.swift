//
//  ExcangeViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 23/09/2020.
//

import UIKit

class ExchangeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var amountToChangeTextField: UITextField!
    @IBOutlet weak var changedValueLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func changeCurrency(_ sender: Any) {
        toggleActivityIndicator(shown: true)
        
        ExchangeService.shared.amountToExchange = "80"
        
        ExchangeService.shared.getConvertion { (success, exchange) in
            self.toggleActivityIndicator(shown: false)
            
            if success, let exchange = exchange {
                self.changedValueLabel.text = String(exchange.result)
            } else {
                let alertVC = UIAlertController(title: "Erreur", message: "Une erreur c'est produite !", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        calculateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}
