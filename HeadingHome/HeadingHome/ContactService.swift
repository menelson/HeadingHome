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
import MNPermissionService

public class ContactService {
    
    let contactStore: CNContactStore = CNContactStore()
    let permissionSVC: MNPermissionService?
    lazy var status = CNContactStore.authorizationStatus(for: .contacts)
    
    init() {
        permissionSVC = MNPermissionService.create(service: .contact)
        permissionSVC?.requestAccess(service: .contact)
    }
        
}
