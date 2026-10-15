//
//  ShareViewController.swift
//  SecondBrainShareExtension
//
//  Created by Grzegorz Bilski on 19.06.26.
//

import UIKit
import Social
import AVFoundation


class ShareViewController: SLComposeServiceViewController, AVSpeechSynthesizerDelegate {
    
    let synthesizer = AVSpeechSynthesizer()
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
   
    override func didSelectPost() {
        
        if let defaults = UserDefaults(
            suiteName: "group.com.grzegorzbilski.secondbrainai"
        ) {
            print("SAVING:")
            print(contentText)
            defaults.set(
                contentText,
                forKey: "sharedText"
            )

            print("APP GROUP SAVED")

            defaults.synchronize()
        }
        
        synthesizer.delegate = self
        
        let alert = UIAlertController(
            title: "Second Brain AI",
            message: "What would you like to do?",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "🔊 Listen Now",
                style: .default
            ) { _ in

                let utterance = AVSpeechUtterance(
                    string: self.contentText
                )

                utterance.voice = AVSpeechSynthesisVoice(
                    language: "pl-PL"
                )

                self.synthesizer.speak(
                    utterance
                )
            }
        )
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )
     
        let controller =
            ShareHostingController(
                text: contentText
            )

        present(
            controller,
            animated: true
        )
    }
    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        print("FINISHED")
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}


//override func didSelectPost() {
//    
//    let alert = UIAlertController(
//            title: "Second Brain",
//            message: contentText,
//            preferredStyle: .alert
//        )
//
//        alert.addAction(
//            UIAlertAction(
//                title: "OK",
//                style: .default
//            )
//        )
//
//        present(
//            alert,
//            animated: true
//        )
//}
