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
        
        if var currentViewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = currentViewController.presentedViewController {
                currentViewController = presentedViewController
            }
            currentViewController.present(picker, animated: true, completion: nil)
        }
    }
    
    // MARK: - ContactPicker Delegates
    
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
        let contact = contactProperty.contact
        let phoneNumber = contactProperty.value as? CNPhoneNumber
        
        print("\(contact.givenName) - \(phoneNumber?.stringValue ?? "Empty")")
    }
        
}
