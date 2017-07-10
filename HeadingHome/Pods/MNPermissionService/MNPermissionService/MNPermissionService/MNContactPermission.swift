//
//  MNContactPermission.swift
//  MNPermissionService
//
//  Created by Mike Nelson on 6/29/17.
//
//

import Foundation
import Contacts
import UIKit

class MNContactPermission: MNPermissionService, MNPermissionFactory {
    typealias EntityType = CNEntityType
    typealias StoreType = CNContactStore
    
    var store = CNContactStore()
    var entity = CNEntityType.contacts
    var message = "Without access to the Contacts some features of the app may not function correctly"
    var title = "Contact Settings"
    
    internal init() {
        super.init(message: message, title: title)
    }

    func requestUserAccess(completionHandler: @escaping (Bool) -> Void) {
        if CNContactStore.authorizationStatus(for: .contacts) == CNAuthorizationStatus.denied {
            repromptUserOfServiceNeed()
        } else {
            store.requestAccess(for: entity, completionHandler: {
                accessGranted, error in
                
                if error != nil {
                    print("Error requesting access")
                }
                
            })
        }
    }
    
}
