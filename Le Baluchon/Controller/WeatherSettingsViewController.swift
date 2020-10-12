//
//  WeatherSettingsViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 04/10/2020.
//

import UIKit

protocol WeatherSelectionDelegate {
    func didEnteredCitiesNames(destinationCityName: String, originCityName: String)
}

class WeatherSettingsViewController: UIViewController {
    
    

    @IBOutlet weak var weatherSettingsHalfView: UIView!
    @IBOutlet weak var originCityTextField: UITextField!
    @IBOutlet weak var destinationCityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherSettingsHalfView.layer.cornerRadius = 15
        self.originCityTextField.backgroundColor = UIColor.white
        self.destinationCityTextField.backgroundColor = UIColor.white
    }
    
    var weatherSelectionDelegate: WeatherSelectionDelegate!

    @IBAction func okButtonTapped(_ sender: Any) {
        
        let formError: WeatherSettingsFormErrors?
        
        guard let originCityName = originCityTextField.text, let destinationCityName = destinationCityTextField.text else {
            return
        }
        
        if originCityName == "" && destinationCityName == ""{
            self.originCityTextField.backgroundColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
            self.destinationCityTextField.backgroundColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
            formError = .noTextFieldAreFilled
            presentAlert(message: formError!.rawValue)
        } else if destinationCityName == "" {
            self.originCityTextField.backgroundColor = UIColor.white
            self.destinationCityTextField.backgroundColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
            formError = .destinationTextFieldIsNotFilled
            presentAlert(message: formError!.rawValue)
        } else if originCityName == "" {
            self.originCityTextField.backgroundColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
            self.destinationCityTextField.backgroundColor = UIColor.white
            formError = .originTextFieldIsNotFilled
            presentAlert(message: formError!.rawValue)
        } else {
            self.originCityTextField.backgroundColor = UIColor.white
            self.destinationCityTextField.backgroundColor = UIColor.white
            weatherSelectionDelegate.didEnteredCitiesNames(destinationCityName: destinationCityName, originCityName: originCityName)
            self.performSegue(withIdentifier: "unwindToWeather", sender: self)
        }
    }
    
    private func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension WeatherSettingsViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: Any) {
        originCityTextField.resignFirstResponder()
        destinationCityTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

enum WeatherSettingsFormErrors: String {
    case originTextFieldIsNotFilled = "Merci d'entrer une vile d'origin"
    case destinationTextFieldIsNotFilled = "Merci d'entrer une ville de destination"
    case noTextFieldAreFilled = "Merci de remplir les champs en rouge"
}
