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
    let weatherService = WeatherService()
    var weatherComparaison: [CityType: CityWeatherResponse?] = [:]
    override func viewDidLoad() {
        compareWeather(between: "Paris", and: "New York")
        let name = Notification.Name("didReceiveData")
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: name, object: nil)
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
        weatherService.getWeatherComparaison(between: originCityName, and: destinationCityName)
    }
    
    private func handleErrors(for cityType: CityType) {
        guard let error = self.weatherService.weatherComparaison[cityType] as? WeatherResponseError else {
            return
        }
        self.presentAlert(message: error.message + "\nMerci d'entrer un nom de ville correct.", handler: self.settingsButtonTapped(_:))
    }
    
    @objc func onDidReceiveData(_ notification:Notification) {
        DispatchQueue.main.async {
            guard let destination = self.weatherService.weatherComparaison[.destination] as? CityWeatherResponse else {
                self.handleErrors(for: .destination)
                return
            }
            
            guard let origin = self.weatherService.weatherComparaison[.origin] as? CityWeatherResponse else {
                self.handleErrors(for: .origin)
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
    
//    private func getWeather(for city: WeatherService, cityName: String, isDestination: Bool) {
//        self.toggleActivityIndicator(shown: true)
//        city.getWeather(for: cityName) { [weak self] (error, weather) in
//            guard let self = self else { return }
//
//            self.toggleActivityIndicator(shown: false)
//            if let weather = weather, error == nil {
//                if isDestination {
//                    self.destinationCityNameLabel.text = weather.name
//                    self.destinationWeatherDescriptionLabel.text = "Description: \n \(weather.weather[0].weatherDescription)"
//                    self.destinationTemperatureLabel.text = self.getStringFromTemp(temperature: weather.main.temp) + " °C"
//                } else {
//                    self.originCityNameLabel.text = weather.name
//                    self.originCityWeatherDescriptionLabel.text = "Description: \n \(weather.weather[0].weatherDescription)"
//                    self.originCityWeatherLabel.text = self.getStringFromTemp(temperature: weather.main.temp) + " °C"
//                }
//            } else {
//                self.toggleActivityIndicator(shown: true)
//                if let serviceError = error {
//                    guard let error = city.error else {
//                        return
//                    }
//
//                    switch error {
//                        case .apiError:
//                            self.presentAlert(message: serviceError.message + "\nMerci d'entrer un nom de ville correct.", handler: self.settingsButtonTapped(_:))
//                        case .notUrlFriendly:
//                            self.presentAlert(message: "Merci d'entrer un nom de ville correct.", handler: self.settingsButtonTapped(_:))
//                    }
//                }
//            }
//        }
//        let weatherViewModel = WeatherViewModel(originCityName: originCityName!, destinationCityName: destinationCityName!, weatherService: WeatherService())
//        for (_, value) in weatherViewModel.weatherErrors {
//            if let error = value {
//                self.presentAlert(message: error.message + "\nMerci d'entrer un nom de ville correct.", handler: self.settingsButtonTapped(_:))
//                return
//            }
//        }
//
//        if weatherViewModel.weatherErrors.count == 0 {
//            self.originCityNameLabel.text = weatherViewModel.weatherInfos[originCityName!]?.name
//            self.originCityWeatherDescriptionLabel.text = "Description: \n \(weatherViewModel.weatherInfos[originCityName!]!.weather[0].weatherDescription)"
//            self.originCityWeatherLabel.text = self.getStringFromTemp(temperature: weatherViewModel.weatherInfos[originCityName!]!.main.temp) + " °C"
//
//            self.destinationCityNameLabel.text = weatherViewModel.weatherInfos[destinationCityName!]?.name
//            self.destinationWeatherDescriptionLabel.text = "Description: \n \(weatherViewModel.weatherInfos[destinationCityName!]!.weather[0].weatherDescription)"
//            self.destinationTemperatureLabel.text = self.getStringFromTemp(temperature: weatherViewModel.weatherInfos[destinationCityName!]!.main.temp) + " °C"
//        }
//    }
    
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

//class WeatherViewModel {
//    var originCityName: String
//    var destinationCityName: String
//    var weatherInfos: [String: CityWeatherResponse] = [:]
//    var weatherErrors: [String: WeatherResponseError?] = [:]
//    var weatherService: WeatherServiceProtocol
//
//    init(originCityName: String, destinationCityName: String, weatherService: WeatherServiceProtocol) {
//        self.originCityName = originCityName
//        self.destinationCityName = destinationCityName
//        self.weatherErrors[originCityName] = nil
//        self.weatherErrors[destinationCityName] = nil
//        self.weatherService = weatherService
//        compareWeather()
//    }
//
//    private func getWeather(for citysName: String) {
//        weatherService.getWeather(for: citysName) { (weatherResponseError, cityWeatherResponse) in
//            self.weatherErrors[citysName] = weatherResponseError
//            self.weatherInfos[citysName] = cityWeatherResponse
//        }
//    }
//
//    func compareWeather() {
//        self.getWeather(for: originCityName)
//        self.getWeather(for: destinationCityName)
//    }
//}
