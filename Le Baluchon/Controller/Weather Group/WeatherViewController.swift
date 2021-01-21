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
        compareWeather(between: self.originCityName!, and: self.destinationCityName!)
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
    override func viewDidLoad() {
        compareWeather(between: "Paris", and: "New York")
        setShadow(to: originWeatherStackView)
        setShadow(to: destinationStackView)
    }
    
    @IBAction func unwindToWeather(segue:UIStoryboardSegue) {}
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        compareWeather(between: self.originCityName!, and: self.destinationCityName!)
    }
    
    private func setShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 15
        view.backgroundColor = #colorLiteral(red: 0.08182520419, green: 0.1225599572, blue: 0.3436949253, alpha: 1)
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
        self.toggleActivityIndicator(shown: true)
        WeatherService.shared.getWeatherComparaison(between: originCityName, and: destinationCityName) { weatherComparaison in
            self.toggleActivityIndicator(shown: false)
            guard let origin = weatherComparaison[.origin] as? CityWeatherResponse else {
                self.handleErrors(for: .origin, weatherComparaison: weatherComparaison)
                return
            }
            
            guard let destination = weatherComparaison[.destination] as? CityWeatherResponse else {
                self.handleErrors(for: .destination, weatherComparaison: weatherComparaison)
                return
            }
            
            self.toggleActivityIndicator(shown: false)
            self.originCityNameLabel.text = origin.name
            self.originCityWeatherDescriptionLabel.text = "Description: \n \(origin.weather[0].weatherDescription)"
            self.originCityWeatherLabel.text = self.getStringFromTemp(temperature: (origin.main.temp)) + " °C"
            
            self.destinationCityNameLabel.text = destination.name
            self.destinationWeatherDescriptionLabel.text = "Description: \n \(destination.weather[0].weatherDescription)"
            self.destinationTemperatureLabel.text = self.getStringFromTemp(temperature: destination.main.temp) + " °C"
        }
    }
    
    private func handleErrors(for cityType: CityType, weatherComparaison: [CityType: Any?]) {
        guard let error = weatherComparaison[cityType] as? WeatherResponseError else {
            return
        }
        self.presentAlert(message: "\(error.message) for \(cityType.rawValue) \nMerci d'entrer un nom de ville correct.", handler: self.settingsButtonTapped)
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        guard let storyBoard = storyboard else {
            return
        }
        if let settingsVC2 = storyBoard.instantiateViewController(withIdentifier: "SettingsVC2") as? SettingsContainerVC {
            settingsVC2.delegate = self
            present(settingsVC2, animated: true, completion: nil)
        }
    }
    
    private func presentAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    deinit {
        print("Weather has been deinited no retain cycle")
    }
}

