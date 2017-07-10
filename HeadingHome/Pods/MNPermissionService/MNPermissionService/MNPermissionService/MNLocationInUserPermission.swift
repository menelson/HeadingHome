//
//  MNLocationInUserPermission.swift
//  MNPermissionService
//
//  Created by Mike Nelson 80044 on 6/30/17.
//
//

import Foundation
import CoreLocation

class MNLocationInUsePermission: MNPermissionService, MNPermissionFactory {
    
    typealias EntityType = String
    typealias StoreType = CLLocationManager
    
    var store = CLLocationManager()
    var entity = "LocationEntity"
    var message = "Without access to the Location some features of the app may not function correctly. Location is only used when the app is in use."
    var title = "Location Settings"
    
    internal init() {
        super.init(message: message, title: title)
    }
    
    func requestUserAccess(completionHandler: @escaping (Bool) -> Void) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            repromptUserOfServiceNeed()
        } else {
            // Request Access
            store.requestWhenInUseAuthorization()
            
            // Only wait if not determined
            while(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined) {
                _ = wait()
            }
            
            // Return true if authorized
            if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
                completionHandler(true)
            }
            
            completionHandler(false)
        }
    }
    
}
