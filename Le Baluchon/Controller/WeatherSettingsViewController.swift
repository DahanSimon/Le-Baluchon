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
        //getCitiesList()
        // Do any additional setup after loading the view.
    }
    
    var weatherSelectionDelegate: WeatherSelectionDelegate!

    @IBAction func okButtonTapped(_ sender: Any) {
        if let originCityName = originCityTextField.text, let destinationCityName = destinationCityTextField.text {
            weatherSelectionDelegate.didEnteredCitiesNames(destinationCityName: destinationCityName, originCityName: originCityName)
        } else {
            print("error")
        }
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
