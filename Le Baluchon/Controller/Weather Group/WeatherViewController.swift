//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 23/09/2020.
//

import UIKit

class WeatherViewController: UIViewController, WeatherSelectionDelegate {
    
    func didEnteredCitiesNames(destinationCityName: String, originCityName: String) {
        self.destinationCityName = destinationCityName
        self.originCityName = originCityName
        compareWeather(between: self.originCityNameUrlFriendly!, and: self.destinationCityNameUrlFriendly!)
    }
    
    @IBOutlet weak var originWeatherStackView: UIStackView!
    @IBOutlet weak var originCityWeatherLabel: UILabel!
    @IBOutlet weak var originCityWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var originActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var originCityNameLabel: UILabel!
    
    @IBOutlet weak var destinationStackView: UIStackView!
    @IBOutlet weak var destinationTemperatureLabel: UILabel!
    @IBOutlet weak var destinationWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var destinationActivityINdicator: UIActivityIndicatorView!
    @IBOutlet weak var destinationCityNameLabel: UILabel!
    
        
    var originCityName: String? = "Paris"
    var destinationCityName: String? = "New York"
    
    var originCityNameUrlFriendly: String? {
        if let originCityName = originCityName{
            return originCityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        } else {
            return nil
        }
    }
    
    var destinationCityNameUrlFriendly: String? {
        if let destinationCityName = destinationCityName{
            return destinationCityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        } else {
            return nil
        }
    }
    override func viewDidLoad() {
        setShadow(to: originWeatherStackView)
        setShadow(to: destinationStackView)
        compareWeather(between: originCityNameUrlFriendly!, and: destinationCityNameUrlFriendly!)
    }
    @IBAction func unwindToWeather(segue:UIStoryboardSegue) {}
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        guard let destinationCityNameUrlFriendly = destinationCityNameUrlFriendly, let originCityNameUrlFriendly = originCityNameUrlFriendly  else {
            presentAlert(message: "Merci de renter des noms de ville correct", handler: nil)
            return
        }
        compareWeather(between: originCityNameUrlFriendly, and: destinationCityNameUrlFriendly)
    }
    
    private func setShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 15
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        originWeatherStackView.isHidden = shown
        originActivityIndicator.isHidden = !shown
        
        destinationStackView.isHidden = shown
        destinationActivityINdicator.isHidden = !shown
        
    }
    
    private func getStringFromTemp(temperature: Double) -> String{
        let intTemp = Int(temperature)
        return String(intTemp)
    }
    
    private func compareWeather(between originCityName: String, and destinationCityName: String) {
        let originWeather = WeatherService(exchangeSession: URLSession(configuration: .default))
        let destinationWeather = WeatherService(exchangeSession: URLSession(configuration: .default))
        
        getWeather(for: originWeather, cityName: originCityName, isDestination: false)
        if originWeather.weatherResponseError == nil {
            getWeather(for: destinationWeather, cityName: destinationCityName, isDestination: true)
        }
    }
    
    private func getWeather(for city: WeatherService, cityName: String, isDestination: Bool) {
        self.toggleActivityIndicator(shown: true)
        city.getWeather(for: cityName) { [weak self] (success, weather) in
            guard let self = self else { return }
            self.toggleActivityIndicator(shown: false)
            if success, let weather = weather {
                if isDestination {
                    self.destinationCityNameLabel.text = weather.name
                    self.destinationWeatherDescriptionLabel.text = "Description: \n \(weather.weather[0].weatherDescription)"
                    self.destinationTemperatureLabel.text = self.getStringFromTemp(temperature: weather.main.temp) + " °C"
                } else {
                    self.originCityNameLabel.text = weather.name
                    self.originCityWeatherDescriptionLabel.text = "Description: \n \(weather.weather[0].weatherDescription)"
                    self.originCityWeatherLabel.text = self.getStringFromTemp(temperature: weather.main.temp) + " °C"
                }
            } else {
                self.toggleActivityIndicator(shown: true)
                if let serviceError = city.weatherResponseError {
                    self.presentAlert(message: serviceError.message + "\nMerci d'entrer un nom de ville correct.", handler: self.settingsButtonTapped(_:))
                }
            }
        }
    }
    

    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let tableViewVC = storyboard?.instantiateViewController(withIdentifier: "tableViewVC") as! WeatherSettingsTableViewController
        tableViewVC.weatherSelectionDelegate = self
        present(tableViewVC, animated: true, completion: nil)
    }
    
    private func presentAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}

