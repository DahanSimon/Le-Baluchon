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
            presentAlert(message: "Please enter some text", handler: nil)
            return
        }
        
        self.translationService.detectAndTranslate(textToTranslate: textToTranslate) { [weak self] (success, translationStruct) in
            
            guard let self = self else { return }
            
            guard let translation = translationStruct else {
                if !success, let serviceError = self.translationService.serviceError {
                    self.presentAlert(message: serviceError.localizedDescription, handler: nil)
                }
                return
            }
            
            self.sourceLanguageLabel.text = translation.sourceLanguage
            self.translatedTextTextField.text = translation.translatedText
        }
        
        dismissKeyboard(self.tapGestureRecongnizer)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textToTranslateTextField.resignFirstResponder()
    }
}
