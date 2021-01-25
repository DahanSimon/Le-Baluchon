//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by Simon Dahan on 23/09/2020.
//

import UIKit

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var textToTranslateTextField: UITextField!
    @IBOutlet weak var translatedTextTextField: UILabel!
    @IBOutlet var tapGestureRecongnizer: UITapGestureRecognizer!
    
    let translationService = TranslationService(api: TranslationGoogleAPI())
    
    @IBAction func translateButtonTapped(_ sender: Any) {
        guard let textToTranslate = self.textToTranslateTextField.text else {
            presentAlert(message: "Please enter some text")
            return
        }
        self.translationService.translate(textToTranslate: textToTranslate) { (success, response) in
            guard let translationResponse = response else {
                return
            }
            self.translatedTextTextField.text = translationResponse.data.translations[0].translatedText
        }
        dismissKeyboard(self.tapGestureRecongnizer)
    }
    
    private func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslateTextField.resignFirstResponder()
    }
}
