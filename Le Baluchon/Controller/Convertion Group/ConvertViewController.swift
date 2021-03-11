//
//  ExcangeViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 23/09/2020.
//

import UIKit

class ConvertViewController: UIViewController, CurrencySelectionDelegate {
    
    enum VCErrors: String {
        case invalidTextFieldInput = "Please enter a correct value."
        case apiError = "An error occured ! Please try again"
    }
    
    // This method transfer the currencies codes that the user selected from the SettingsVC to the ConvertVC
    func didSelectCurrency(convertTo_CurrencyCode: String, baseCurrencyCode: String) {
        self.selectedConvertToCurrencyCode = convertTo_CurrencyCode
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
    var selectedConvertToCurrencyCode = "USD"
    var selectedBaseCurrencyCode = "EUR"
    
    override func viewDidLoad() {
        self.baseCurrencySymbol.layer.zPosition = 1000
        self.amountToChangeTextField.layer.zPosition = 1
        
        // Get the rate at the beginnig to display it on the rateInfoLabel
        ConvertionService.shared.getConvertion(amountToConvert: 1.0, convertToCurrencyCode: selectedConvertToCurrencyCode) { [weak self] (requestResponse, result) in
            guard let self = self else { return }
            self.toggleActivityIndicator(shown: false)
            switch requestResponse {
            case .failure(let serviceError):
                self.presentAlert(message: serviceError.localizedDescription, handler: nil)
            case .success(_):
                if let convertionResult = result {
                    self.rateInfoLabel.text = "1 € = " + String(format: "%.4f $", convertionResult)
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
        ConvertionService.shared.getConvertion(amountToConvert: amountToConvert, convertToCurrencyCode: selectedConvertToCurrencyCode) { [weak self] (requestResponse, result) in
            guard let self = self else { return }
            guard let convertionResult = result else { return }
            self.toggleActivityIndicator(shown: false)
            
            switch requestResponse {
            case .failure(let serviceError):
                self.presentAlert(message: serviceError.localizedDescription, handler: nil)
            case .success(let convertionResponse):
                let convertToCurrencySymbol = Currency.share.data[self.selectedConvertToCurrencyCode]!.symbol
                let baseCurrencySymbol = Currency.share.data[self.selectedBaseCurrencyCode]!.symbol
                self.baseCurrencySymbol.text = baseCurrencySymbol
                self.changedValueLabel.text = String(format: "%.2f \(convertToCurrencySymbol)", convertionResult)
                self.rateInfoLabel.text = "1 \(baseCurrencySymbol) = " + String(format: "%.4f \(convertToCurrencySymbol)", convertionResponse.rates[self.selectedConvertToCurrencyCode]!)
            }
        }
    }
    
    
    @IBAction func unwindToConvertion(segue:UIStoryboardSegue) {}
    
    // Presents SettingsView and set his delgate as ConvertionViewController
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
                        
