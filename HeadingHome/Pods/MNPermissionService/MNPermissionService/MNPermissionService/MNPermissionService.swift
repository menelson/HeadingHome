//
//  MNPermissionProtocol.swift
//  MNPermissionService
//
//  Created by Mike Nelson on 6/29/17.
//
//

import Foundation
import EventKit
import Contacts
import UIKit

public class MNPermissionService {
    fileprivate var messageInternal: String?
    fileprivate var titleInternal: String?
    
    internal init(message: String, title: String) {
        self.messageInternal = message
        self.titleInternal = title
    }
    
    public class func create(service: MNPermissionType) -> MNPermissionService {
        var result: MNPermissionService
        
        switch service {
        case .calendar:
            result = MNCalendarPermission()
            break
        case .contact:
            result = MNContactPermission()
            break
        case .locationInUse:
            result = MNLocationInUsePermission()
            break
        }
        
        return result
    }
    
    public func requestAccess(service: MNPermissionType) {
        
        switch service {
        case .calendar:
            MNCalendarPermission().requestUserAccess(completionHandler: { (granted) in
                if !granted {
                    print("Permission not available")
                }
            })
            break
        case .contact:
            MNContactPermission().requestUserAccess(completionHandler: { (granted) in
                if !granted {
                    print("Permission not available")
                }
            })
            break
        case .locationInUse:
            MNLocationInUsePermission().requestUserAccess(completionHandler: { (granted) in
                
            })
            break
        }
    }
    
    func repromptUserOfServiceNeed() {
        let dialog = UIAlertController(title: titleInternal, message: messageInternal, preferredStyle: .alert)
        
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
