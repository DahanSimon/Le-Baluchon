//
//  ConvertSettingsViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 01/10/2020.
//

import UIKit

class ConvertSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingHalfView.layer.cornerRadius = 15
    }
    @IBOutlet weak var settingHalfView: UIView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
