//
//  WeatherSettingsTableViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 13/10/2020.
//

import UIKit

protocol WeatherSelectionDelegate {
    func didEnteredCitiesNames(destinationCityName: String, originCityName: String)
}

class WeatherSettingsTableViewController: UITableViewController {

    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet weak var originCityTextField: UITextField!
    @IBOutlet weak var destinationCityTextField: UITextField!

    override func viewDidAppear(_ animated: Bool) {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        tableView.frame = CGRect(x: 0, y: height/3, width: tableView.frame.size.width, height: tableView.contentSize.height)
        tableView.isHidden = false
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        self.settingsTableView.layer.cornerRadius = 15
        self.originCityTextField.backgroundColor = UIColor.white
        self.destinationCityTextField.backgroundColor = UIColor.white
        super.viewDidLoad()
    }
    
    
    
    var weatherSelectionDelegate: WeatherSelectionDelegate!

    @IBAction func showtableViewButtonTapped(_ sender: Any) {
        let tableViewVC = storyboard?.instantiateViewController(withIdentifier: "tableViewVC") as! WeatherSettingsTableViewController
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        tableViewVC.tableView.frame = CGRect(x: 0, y: height/3, width: tableViewVC.tableView.frame.size.width, height: tableViewVC.tableView.contentSize.height)
        present(tableViewVC, animated: true) {
            let guide = self.view.safeAreaLayoutGuide
            let height = guide.layoutFrame.size.height
            tableViewVC.tableView.frame = CGRect(x: 0, y: height/3, width: tableViewVC.tableView.frame.size.width, height: tableViewVC.tableView.contentSize.height)
        }
    }
    
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
            self.performSegue(withIdentifier: "unwindToWeather2", sender: self)
        }
    }
    
    private func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension WeatherSettingsTableViewController: UITextFieldDelegate {
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
