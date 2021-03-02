//
//  ExcangeViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 23/09/2020.
//

import UIKit

class ConvertViewController: UIViewController, CurrencySelectionDelegate {
    
    enum VCErrors: String {
        case invalidTextFieldInput = "Merci d'entrer une valeur correct."
        case apiError = "Une erreur c'est produite ! Merci de réessayer."
    }
    
    enum test {
        case random(String)
    }
    
    func didSelectCurrency(convertTo_CurrencyCode: String, baseCurrencyCode: String) {
        self.selectedConvertTo_CurrencyCode = convertTo_CurrencyCode
        self.selectedBaseCurrencyCode = baseCurrencyCode
        ConvertionService.shared.baseCurrency = baseCurrencyCode
        callApi(amountToConvert: 0.0)
        
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
    
    private func formatTextField(currencyCode: String) {
        let formatter = NumberFormatter()
        formatter.currencyCode = currencyCode
        formatter.numberStyle = .currency
        formatter.locale = NSLocale(localeIdentifier: "us") as Locale
    }
    
    override func viewDidLoad() {
        self.baseCurrencySymbol.layer.zPosition = 1000
        self.amountToChangeTextField.layer.zPosition = 1
        ConvertionService.shared.convert { [weak self] (requestResponse) in
            
            guard let self = self else { return }
            
            self.toggleActivityIndicator(shown: false)
            
            switch requestResponse {
            case .failure(let serviceError):
                self.presentAlert(message: serviceError.localizedDescription, handler: nil)
            case .success(let convertionResponse):
                if let rate = convertionResponse.rates["USD"] {
                    self.rateInfoLabel.text = "1 € = " + String(format: "%.4f $", rate)
                } else {
                    self.rateInfoLabel.isHidden = true
                }
            }
        }
    }
    
    @IBAction func calculate(_ sender: Any) {
        toggleActivityIndicator(shown: true)
        dismissKeyboard(tapGestureRecognizer)
        
        guard let amountToConvertString = amountToChangeTextField?.text else {
            toggleActivityIndicator(shown: false)
            return
        }
        
        guard let amountToConvert = Double(amountToConvertString) else {
            toggleActivityIndicator(shown: false)
            presentAlert(message: VCErrors.invalidTextFieldInput.rawValue, handler: nil)
            return
        }
        callApi(amountToConvert: amountToConvert)
    }
    
    
    
    private func toggleActivityIndicator(shown: Bool) {
        calculateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    func callApi(amountToConvert: Double) {
        ConvertionService.shared.convert { [weak self] (requestResponse) in
            
            guard let self = self else { return }
            
            self.toggleActivityIndicator(shown: false)
            
            switch requestResponse {
            
            case .failure(let serviceError):
                self.presentAlert(message: serviceError.localizedDescription, handler: nil)
            case .success(let convertionResponse):
                let rate = convertionResponse.rates[self.selectedConvertTo_CurrencyCode]!
                let result = self.convert(amount: amountToConvert, rate: rate)
                
                let convertTo_CurrencySymbol = Currency.share.data[self.selectedConvertTo_CurrencyCode]!.symbol
                let baseCurrencySymbol = Currency.share.data[self.selectedBaseCurrencyCode]!.symbol
                self.baseCurrencySymbol.text = baseCurrencySymbol
                self.changedValueLabel.text = String(format: "%.2f \(convertTo_CurrencySymbol)", result)
                self.rateInfoLabel.text = "1 \(baseCurrencySymbol) = " + String(format: "%.4f \(convertTo_CurrencySymbol)", convertionResponse.rates[self.selectedConvertTo_CurrencyCode]!)
            }
        }
    }
    
    private func convert(amount: Double, rate: Double) -> Double {
        return amount * rate
    }
    
    @IBAction func unwindToConvertion(segue:UIStoryboardSegue) {}
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let selectionVC = storyboard?.instantiateViewController(withIdentifier: "settingsViewController") as! ConvertSettingsViewController
        selectionVC.selectionDelegate = self
        present(selectionVC, animated: true, completion: nil)
    }
    deinit {
        print("Convertion has been deinited no retain cycle")
    }
}

extension ConvertViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountToChangeTextField.resignFirstResponder()
    }
}
                        
