//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 23/09/2020.
//

import UIKit

class WeatherViewController: UIViewController, WeatherSelectionDelegate {
    
    // This method transfer the city's name that the user entered from the WeatherSettingsVC to the WeatherVC
    func didEnterCitiesNames(destinationCityName: String, originCityName: String) {
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
    
    private func getString(from temperature: Double) -> String{
        let intTemp = Int(temperature)
        return String(intTemp)
    }
    
    private func compareWeather(between originCityName: String, and destinationCityName: String) {
        self.toggleActivityIndicator(shown: true)
        WeatherService.shared.getWeatherComparaison(between: originCityName, and: destinationCityName) { [weak self] weatherComparaison in
            
            guard let self = self else { return }
            
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
            self.updateView(for: .origin, name: origin.name, description: origin.weather[0].weatherDescription, temp: origin.main.temp)
            self.updateView(for: .destination, name: destination.name, description: destination.weather[0].weatherDescription, temp: destination.main.temp)
        }
    }
    
    private func updateView(for cityType: CityType, name: String, description: String, temp: Double) {
        switch cityType {
        case .origin:
            self.originCityNameLabel.text = name
            self.originCityWeatherDescriptionLabel.text = "Description: \n \(description)"
            self.originCityWeatherLabel.text = self.getString(from: temp) + " °C"
        case .destination:
            self.destinationCityNameLabel.text = name
            self.destinationWeatherDescriptionLabel.text = "Description: \n \(description)"
            self.destinationTemperatureLabel.text = self.getString(from: temp) + " °C"
        }
    }
    
    private func handleErrors(for cityType: CityType, weatherComparaison: [CityType: Any?]) {
        guard let error = weatherComparaison[cityType] as? WeatherResponseError else {
            return
        }
        presentAlert(message: "\(error.message) for \(cityType.rawValue) \nPlease enter a valid city name", handler: self.settingsButtonTapped)
    }
    // Presents SettingsContainerVC and set his delgate as WeatherViewController
    @IBAction func settingsButtonTapped(_ sender: Any) {
        guard let storyBoard = storyboard else {
            return
        }
        if let settingsVC2 = storyBoard.instantiateViewController(withIdentifier: "SettingsVC2") as? SettingsContainerVC {
            settingsVC2.delegate = self
            present(settingsVC2, animated: true, completion: nil)
        }
    }
}

