//
//  ExcangeViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 23/09/2020.
//

import UIKit

@available(iOS 13.0, *)
class ConvertViewController: UIViewController, UITextFieldDelegate, CurrencySelectionDelegate {
    func didSelectCurrency(convertTo_CurrencyCode: String, baseCurrencyCode: String) {
        self.selectedConvertTo_CurrencyCode = convertTo_CurrencyCode
        self.selectedBaseCurrencyCode = baseCurrencyCode
    }
        
    @IBOutlet weak var baseCurrencySymbol: UILabel!
    @IBOutlet weak var amountToChangeTextField: UITextField!
    @IBOutlet weak var changedValueLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var rateInfoLabel: UILabel!
    
    var selectedConvertTo_CurrencyCode = "USD"
    var selectedBaseCurrencyCode = "EUR"
    
    enum VCErrors: String {
        case invalidTextFieldInput = "Merci d'entrer une valeur correct."
        case apiError = "Une erreur c'est produite ! Merci de réessayer."
    }
    
    override func viewDidLoad() {
        ConvertionService.shared.getConvertion { [self] (success, exchange) in
            toggleActivityIndicator(shown: false)
            
            if success, let exchange = exchange {
                let rate = exchange.rates["USD"]!
                rateInfoLabel.text = "1 € = " + String(format: "%.4f $", rate)
            } else {
                rateInfoLabel.isHidden = true
            }
        }
    }
    
    @IBAction func calculate(_ sender: Any) {
        toggleActivityIndicator(shown: true)
        dismissKeyboard(tapGestureRecognizer)
        
        // Is Valuable ?
        guard let amountToConvertString = amountToChangeTextField.text else {
            toggleActivityIndicator(shown: false)
            return
        }
        
        guard let amountToConvert = Double(amountToConvertString) else {
            toggleActivityIndicator(shown: false)
            presentAlert(vcError: .invalidTextFieldInput)
            return
        }
        callApi(amountToConvert: amountToConvert)
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
    
    private func convert(amount: Double, rate: Double) -> Double {
        return amount * rate
    }
    
    private func presentAlert(vcError: VCErrors) {
        let alertVC = UIAlertController(title: "Erreur", message: vcError.rawValue, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func unwindToConvertion(segue:UIStoryboardSegue) { }
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let selectionVC = storyboard?.instantiateViewController(identifier: "settingsViewController") as! ConvertSettingsViewController
        selectionVC.selectionDelegate = self
        present(selectionVC, animated: true, completion: nil)
    }
    
    func callApi(amountToConvert: Double) {
        ConvertionService.shared.getConvertion { [self] (success, exchange) in
            toggleActivityIndicator(shown: false)
            
            if success, let exchange = exchange {
                
                let rate = exchange.rates[selectedConvertTo_CurrencyCode]!
                let result = self.convert(amount: amountToConvert, rate: rate)

                let convertTo_CurrencySymbol = Currency.share.data[selectedConvertTo_CurrencyCode]!.symbol
                let baseCurrencySymbol = Currency.share.data[selectedBaseCurrencyCode]!.symbol
                self.baseCurrencySymbol.text = baseCurrencySymbol
                changedValueLabel.text = String(format: "%.2f \(convertTo_CurrencySymbol)", result)
                rateInfoLabel.text = "1 \(baseCurrencySymbol) = " + String(format: "%.4f \(convertTo_CurrencySymbol)", exchange.rates[selectedConvertTo_CurrencyCode]!)
            } else {
                presentAlert(vcError: .apiError)
            }
        }
    }
}
