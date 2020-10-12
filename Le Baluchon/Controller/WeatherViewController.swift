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
    
    override func viewDidAppear(_ animated: Bool) {
        print("äppear")
    }
    
    @IBAction func unwindToWeather(segue:UIStoryboardSegue) {}
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        guard let destinationCityNameUrlFriendly = destinationCityNameUrlFriendly, let originCityNameUrlFriendly = originCityNameUrlFriendly  else {
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
        getWeather(for: destinationWeather, cityName: destinationCityName, isDestination: true)
    }
    
    private func getWeather(for city: WeatherService, cityName: String, isDestination: Bool) {
        self.toggleActivityIndicator(shown: true)
        city.getWeather(for: cityName) { [weak self] (success, weather) in
            guard let self = self else { return }
            self.toggleActivityIndicator(shown: false)
            if success, let weather = weather {
                if isDestination {
                    self.destinationCityNameLabel.text = self.destinationCityName
                    self.destinationWeatherDescriptionLabel.text = "WEATHER INFO : \n \(weather.weather[0].weatherDescription)"
                    self.destinationTemperatureLabel.text = self.getStringFromTemp(temperature: weather.main.temp) + " °C"
                } else {
                    self.originCityNameLabel.text = self.originCityName
                    self.originCityWeatherDescriptionLabel.text = "WEATHER INFO : \n \(weather.weather[0].weatherDescription)"
                    self.originCityWeatherLabel.text = self.getStringFromTemp(temperature: weather.main.temp) + " °C"
                }
            } else {
                self.toggleActivityIndicator(shown: true)
                self.presentAlert()
            }
        }
    }
    

    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let weatherSelectionVC = storyboard?.instantiateViewController(withIdentifier: "weatherSettingsVC") as! WeatherSettingsViewController
        weatherSelectionVC.weatherSelectionDelegate = self
        present(weatherSelectionVC, animated: true, completion: nil)
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Une erreur c'est produite merci de rafraichir.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: refreshButtonTapped(_:))
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
}
