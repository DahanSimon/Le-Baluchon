//
//  SettingsContainerVC.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 15/10/2020.
//

import UIKit

class SettingsContainerVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var weatherSettingsTableVC: WeatherSettingsTableViewController!
    
    weak var delegate: WeatherSelectionDelegate?
    
    /* Create an instance of WeatherSettingsTableViewController and set his delegate with the instance of WeatherViewController that is already set as the delegate of the SettingsContainerVC */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WeatherSettingsTableViewController {
            self.weatherSettingsTableVC = vc
            self.weatherSettingsTableVC.weatherSelectionDelegate = self.delegate
        }
    }
}
