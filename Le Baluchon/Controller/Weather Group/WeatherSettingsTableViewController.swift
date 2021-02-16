//
//  WeatherSettingsTableViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 13/10/2020.
//

import UIKit

protocol WeatherSelectionDelegate: class {
    func didEnterCitiesNames(destinationCityName: String, originCityName: String)
}

class WeatherSettingsTableViewController: UITableViewController {

    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet weak var originCityTextField: UITextField!
    @IBOutlet weak var destinationCityTextField: UITextField!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    
    
    override func viewDidLoad() {
        self.settingsTableView.layer.cornerRadius = 15
        self.originCityTextField.backgroundColor = UIColor.white
        self.destinationCityTextField.backgroundColor = UIColor.white
        
        self.originCityTextField.delegate = self
        self.destinationCityTextField.delegate = self
        super.viewDidLoad()
    }
    
    var weatherSelectionDelegate: WeatherSelectionDelegate!

    
    @IBAction func okButtonTapped(_ sender: Any) {
        let formError: WeatherSettingsFormErrors?
        
        guard let originCityName = originCityTextField.text, let destinationCityName = destinationCityTextField.text else {
            return
        }
        
        if originCityName.isEmpty && destinationCityName.isEmpty {
            self.originCityTextField.backgroundColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
            self.destinationCityTextField.backgroundColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
            formError = .noTextFieldAreFilled
            presentAlert(message: formError!.rawValue)
        } else if destinationCityName .isEmpty {
            self.originCityTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.destinationCityTextField.backgroundColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
            formError = .destinationTextFieldIsNotFilled
            presentAlert(message: formError!.rawValue)
        } else if originCityName.isEmpty {
            self.originCityTextField.backgroundColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
            self.destinationCityTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            formError = .originTextFieldIsNotFilled
            presentAlert(message: formError!.rawValue)
        } else {
            self.originCityTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.destinationCityTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            weatherSelectionDelegate.didEnterCitiesNames(destinationCityName: destinationCityName, originCityName: originCityName)
            self.performSegue(withIdentifier: "unwindToWeather", sender: self)
        }
        
        
    }
    
    private func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    deinit {
        print("Weather has been deinited no retain cycle")
    }
}

extension WeatherSettingsTableViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        originCityTextField.resignFirstResponder()
        destinationCityTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

enum WeatherSettingsFormErrors: String {
    case originTextFieldIsNotFilled = "Merci d'entrer une vile d'origine"
    case destinationTextFieldIsNotFilled = "Merci d'entrer une ville de destination"
    case noTextFieldAreFilled = "Merci de remplir les champs en rouge"
    case entryIsWrong = "Merci d'entrer un nom de ville valide"
}
