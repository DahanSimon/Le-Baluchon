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
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    
    @IBAction func changeCurrency(_ sender: Any) {
        toggleActivityIndicator(shown: true)
        dismissKeyboard(tapGestureRecognizer)
        
        ConvertionService.shared.amountToConvertString = amountToChangeTextField.text!
        
        ConvertionService.shared.getConvertion { (success, exchange) in
            self.toggleActivityIndicator(shown: false)
            
            if success, let exchange = exchange {
                self.changedValueLabel.text = String(format: "%.2f $", exchange.result!)
            } else {
                let alertVC = UIAlertController(title: "Erreur", message: "Une erreur c'est produite !", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountToChangeTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        calculateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}
