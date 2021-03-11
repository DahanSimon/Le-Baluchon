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
    @IBOutlet weak var convertToCurrencyPickerView: UIPickerView!
    @IBOutlet weak var baseCurrencyPickerView: UIPickerView!
    @IBOutlet weak var settingHalfView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingHalfView.layer.cornerRadius = 15
        populateData()
    }
    
    var ratesCityCode:[String: String] = [:]
    var currenciesArray: [String] = []
    var selectionDelegate: CurrencySelectionDelegate!
    

    @IBAction func okButtonTapped(_ sender: Any) {
        let convertTo_CurrencyCode = getCurrenciesCode(pickerView: self.convertToCurrencyPickerView)
        let baseCurrencyCode = getCurrenciesCode(pickerView: self.baseCurrencyPickerView)
        selectionDelegate.didSelectCurrency(convertTo_CurrencyCode: convertTo_CurrencyCode, baseCurrencyCode: baseCurrencyCode)
    }
    
    private func createArrayFormDictionnary(dict: [String: String]) -> [String]{
        var array: [String] = []
        for (key, value) in dict {
            array.append(key + " - \(value)")
        }
        return array.sorted()
    }
    
    func getCurrenciesCode(pickerView: UIPickerView) -> String {
        let currencyIndex = pickerView.selectedRow(inComponent: 0)
        let currency = currenciesArray[currencyIndex]
        let currencyCode = currency.split(separator: " ").first!
        return String(currencyCode)
    }
    
    /* Check what currencies are available from the api and match the currency
        code from currecies save in CurrenciesData.json */
    func populateData() {
        for (code, _) in Currency.share.data {
            if let _ = ConvertionService.shared.convertionResponse?.rates[code] {
                ratesCityCode[code] = Currency.share.data[code]?.name
            }
        }
        self.currenciesArray = createArrayFormDictionnary(dict: ratesCityCode)
    }
}

extension ConvertSettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratesCityCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currenciesArray[row]
    }
    
}


