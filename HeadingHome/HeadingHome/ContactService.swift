//
//  ContactService.swift
//  HeadingHome
//
//  Created by Mike Nelson on 6/26/17.
//
//

import Foundation
import Contacts
import ContactsUI
import UIKit

public class ContactService {
    
    let contactStore: CNContactStore = CNContactStore()
    
    
    init() {
        checkPermissions()
    }
    
    func checkPermissions() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .notDetermined:
            requestAccess()
            break
        case .denied, .restricted:
            promptAndInformUser()
            break
        case .authorized:
            // Do things
            break
        }
    }
    
    func requestAccess() {
        contactStore.requestAccess(for: .contacts) {
            (granted, error) in
            
            if error != nil {
                print("Error requesting access")
            }
            
            if granted {
                // Do things
            } else {
                self.promptAndInformUser()
            }
        }
    }
    
    func promptAndInformUser() {
        let message = "Conatacts are used to provide a default person to send messages. Without Access to Contacts, some features of the app will not work correctly."
        
        let dialog = UIAlertController(title: "Contact Permission", message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {
            action in
            
            let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(settingsURL!, options: [:], completionHandler: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        dialog.addAction(settingsAction)
        dialog.addAction(cancelAction)
        
        if var currentViewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = currentViewController.presentedViewController {
                currentViewController = presentedViewController
            }
            
            currentViewController.present(dialog, animated: true, completion: nil)
        }
    }
    
}
