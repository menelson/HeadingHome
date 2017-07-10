//
//  File.swift
//  HeadingHome
//
//  Created by Mike Nelson on 7/10/17.
//
//

import Foundation
import MNPermissionService

class LocationManager: NSObject {
    
    var service: MNPermissionService?
    
    override init() {
        super.init()
        
        service = MNPermissionService.create(service: .locationInUse)
        service?.requestAccess(service: .locationInUse)
    }
}
