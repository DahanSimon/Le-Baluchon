//
//  ConvertSettingsViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 01/10/2020.
//

import UIKit

protocol CurrencySelectionDelegate {
    func didSelectCurrency(convertTo_CurrencyCode: String, baseCurrencyCode: String)
}

class ConvertSettingsViewController: UIViewController {
    @IBOutlet weak var convertTo_CurrencyPickerView: UIPickerView!
    @IBOutlet weak var baseCurrencyPickerView: UIPickerView!
    @IBOutlet weak var settingHalfView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingHalfView.layer.cornerRadius = 15
        checkData()
    }
    
    var currenciesArray: [String] = []
    var selectionDelegate: CurrencySelectionDelegate!
    

    private func createArrayFormDictionnary(dict: [String: String]) {
        var array: [String] = []
        for (key, value) in dict {
            array.append(key + "  \(value)")
        }
        currenciesArray = array.sorted()
    }
    
    func getCurrenciesCode(pickerView: UIPickerView) -> String {
        createArrayFormDictionnary(dict: ratesCityCode)
        let currencyIndex = pickerView.selectedRow(inComponent: 0)
        let currency = currenciesArray[currencyIndex]
        let currencyCode = currency.split(separator: " ").first!
        return String(currencyCode)
    }
    
    var ratesCityCode:[String: String] = [:]
    
}

extension ConvertSettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratesCityCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        createArrayFormDictionnary(dict: ratesCityCode)
        return currenciesArray[row]
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        let convertTo_CurrencyCode = getCurrenciesCode(pickerView: self.convertTo_CurrencyPickerView)
        let baseCurrencyCode = getCurrenciesCode(pickerView: self.baseCurrencyPickerView)
        selectionDelegate.didSelectCurrency(convertTo_CurrencyCode: convertTo_CurrencyCode, baseCurrencyCode: baseCurrencyCode)
    }
    
    func checkData() {
        let currencyData = Currency()
        for (key, _) in currencyData.data {
            ratesCityCode[key] = currencyData.data[key]?.name
        }
    }
}


