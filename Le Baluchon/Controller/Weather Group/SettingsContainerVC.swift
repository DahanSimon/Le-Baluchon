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
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        self.weatherSettingsTableVC.tableView.frame = CGRect(x: 0, y: height/2, width: self.weatherSettingsTableVC.tableView.frame.size.width, height: 400)
    }
    
    private var weatherSettingsTableVC: WeatherSettingsTableViewController!
    
    var delegate: WeatherSelectionDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WeatherSettingsTableViewController {
            self.weatherSettingsTableVC = vc
            self.weatherSettingsTableVC.weatherSelectionDelegate = self.delegate
        }
    }
}
