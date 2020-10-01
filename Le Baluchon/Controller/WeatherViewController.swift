//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 23/09/2020.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var originWeatherStackView: UIStackView!
    @IBOutlet weak var originCityWeatherLabel: UILabel!
    @IBOutlet weak var originCityWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var originActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var destinationStackView: UIStackView!
    @IBOutlet weak var destinationTemperatureLabel: UILabel!
    @IBOutlet weak var destinationWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var destinationActivityINdicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        setShadow(to: originWeatherStackView)
        setShadow(to: destinationStackView)
        
        compareWeather(between: "Paris", and: "New%20York")
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        compareWeather(between: "Paris", and: "New%20York")
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
        getWeather(for: destinationWeather, cityName: destinationCityName, isDestination: true)
    }
    
    private func getWeather(for city: WeatherService, cityName: String, isDestination: Bool) {
        self.toggleActivityIndicator(shown: true)
        city.getWeather(for: cityName) { [self] (success, weather) in
            toggleActivityIndicator(shown: false)
            if success, let weather = weather {
                if isDestination {
                    destinationWeatherDescriptionLabel.text = "WEATHER INFO : \n \(weather.weather[0].weatherDescription)"
                    destinationTemperatureLabel.text = getStringFromTemp(temperature: weather.main.temp) + " °C"
                } else {
                    originCityWeatherDescriptionLabel.text = "WEATHER INFO : \n \(weather.weather[0].weatherDescription)"
                    originCityWeatherLabel.text = getStringFromTemp(temperature: weather.main.temp) + " °C"
                }
            } else {
                toggleActivityIndicator(shown: true)
                presentAlert()
            }
        }
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Une erreur c'est produite merci de rafraichir.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: refreshButtonTapped(_:))
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}
