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

public class ContactService: NSObject, CNContactPickerDelegate {
    
    let contactStore: CNContactStore = CNContactStore()
    let permissionSVC: MNPermissionService?
    lazy var status = CNContactStore.authorizationStatus(for: .contacts)
    
    override init() {
        permissionSVC = MNPermissionService.create(service: .contact)
        permissionSVC?.requestAccess(service: .contact)
    }
    
    func showContactPicker() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        
        let current = Helper.sharedInstance.getCurrentViewController()
        
        current.present(picker, animated: true, completion: nil)
    }
    
    func saveContactDefaults(name: String, number: String) {
        AppDefaults.sharedInstance.setString(item: name, key: appKeys.contactName.rawValue)
        AppDefaults.sharedInstance.setString(item: number, key: appKeys.contactNumber.rawValue)
    }
    
    func getContactDefaults() -> (String, String) {
        let name = AppDefaults.sharedInstance.getString(key: appKeys.contactName.rawValue)
        let number = AppDefaults.sharedInstance.getString(key: appKeys.contactNumber.rawValue)
        
        return (name, number)
    }
    
    // MARK: - ContactPicker Delegates
    
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
        let contact = contactProperty.contact
        let phoneNumber = contactProperty.value as? CNPhoneNumber
        
        saveContactDefaults(name: contact.givenName, number: (phoneNumber?.stringValue)!)
    }
        
}
