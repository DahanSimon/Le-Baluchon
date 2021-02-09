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
    @IBOutlet weak var sourceLanguageLabel: UILabel!
    
    let translationService = TranslationService(api: TranslationGoogleAPI())
    
    
    @IBAction func translateButtonTapped(_ sender: Any) {
        
                
        guard let textToTranslate = self.textToTranslateTextField.text else {
            return
        }
        
        if textToTranslate.isEmpty {
            presentAlert(message: "Please enter some text")
            return
        }
        
        self.translationService.detectAndTranslate(textToTranslate: textToTranslate) { (success, translationStruct) in
            guard let translation = translationStruct else {
                if let detectionError = self.translationService.detectionError, detectionError == .undefined {
                    self.presentAlert(message: detectionError.localizedDescription)
                }
                
                if let translationErrorMessage = self.translationService.translationErrorMessage {
                    self.presentAlert(message: translationErrorMessage)
                }
                return
            }
            
            self.sourceLanguageLabel.text = translation.sourceLanguage
            self.translatedTextTextField.text = translation.translatedText
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
