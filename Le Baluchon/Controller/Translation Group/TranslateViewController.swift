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
        
        var languagesCodeData: Data? {
            let bundle = Bundle(for: TranslationService.self)
            let url = bundle.url(forResource: "LanguagesCodesData", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
        
        guard let languagesCodes = try? JSONDecoder().decode(LanguagesCodes.self, from: languagesCodeData!) else {
            return
        }
        
        guard let textToTranslate = self.textToTranslateTextField.text else {
            return
        }
        
        if textToTranslate == "" {
            presentAlert(message: "Please enter some text")
            return
        }
        
        self.translationService.detectAndTranslate(textToTranslate: textToTranslate) { (success, translationStruct) in
            guard let translation = translationStruct else {
                return
            }
            self.sourceLanguageLabel.text = languagesCodes[translation.sourceLanguage!]?.name
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
