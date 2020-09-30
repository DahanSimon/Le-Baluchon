//
//  ExcangeViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 23/09/2020.
//

import UIKit

class ConvertViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var amountToChangeTextField: UITextField!
    @IBOutlet weak var changedValueLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var rateInfoLabel: UILabel!
    
    override func viewDidLoad() {
        ConvertionService.shared.getConvertion { (success, exchange) in
            self.toggleActivityIndicator(shown: false)
            
            if success, let exchange = exchange {
                self.rateInfoLabel.text = "1 € = \(exchange.rates.usd) $"
            }
        }
    }
    
    @IBAction func calculate(_ sender: Any) {
        toggleActivityIndicator(shown: true)
        dismissKeyboard(tapGestureRecognizer)
        
        guard let amountToConvertString = amountToChangeTextField.text else {
            return
        }
        guard let amountToConvert = Double(amountToConvertString) else {
            return
        }
        
        ConvertionService.shared.getConvertion { (success, exchange) in
            self.toggleActivityIndicator(shown: false)
            
            if success, let exchange = exchange {
                let result = self.convert(amount: amountToConvert, rate: exchange.rates)
                self.changedValueLabel.text = String(format: "%.2f $", result)
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
    
    private func convert(amount: Double, rate: Rates) -> Double {
        return amount * rate.usd
    }
}
