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
    
    enum VCErrors: String {
        case invalidTextFieldInput = "Merci d'entrer une valeur correct."
        case apiError = "Une erreur c'est produite ! Merci de réessayer."
    }
    
    override func viewDidLoad() {
        ConvertionService.shared.getConvertion { (success, exchange) in
            self.toggleActivityIndicator(shown: false)
            
            if success, let exchange = exchange {
                self.rateInfoLabel.text = "1 € = \(exchange.rates.usd) $"
            } else {
                self.rateInfoLabel.isHidden = true
            }
        }
    }
    
    @IBAction func calculate(_ sender: Any) {
        toggleActivityIndicator(shown: true)
        dismissKeyboard(tapGestureRecognizer)
        
        // Is Valuable ?
        guard let amountToConvertString = amountToChangeTextField.text else {
            self.toggleActivityIndicator(shown: false)
            return
        }
        
        guard let amountToConvert = Double(amountToConvertString) else {
            self.toggleActivityIndicator(shown: false)
            presentAlert(vcError: .invalidTextFieldInput)
            return
        }
        
        ConvertionService.shared.getConvertion { (success, exchange) in
            self.toggleActivityIndicator(shown: false)
            
            if success, let exchange = exchange {
                let result = self.convert(amount: amountToConvert, rate: exchange.rates)
                self.changedValueLabel.text = String(format: "%.2f $", result)
            } else {
                self.presentAlert(vcError: .apiError)
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
    
    private func presentAlert(vcError: VCErrors) {
        let alertVC = UIAlertController(title: "Erreur", message: vcError.rawValue, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}
