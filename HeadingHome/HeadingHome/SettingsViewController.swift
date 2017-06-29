//
//  SettingsViewController.swift
//  HeadingHome
//
//  Created by Mike Nelson on 6/25/17.
//
//

import UIKit
import Contacts
import ContactsUI

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.dataSource = self
        tableView?.delegate = self
        
        _ = ContactService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Default Contact"
        } else if section == 1 {
            return "Home Address"
        }
        return "N/A"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            if !(CNContactStore.authorizationStatus(for: .contacts) == .authorized) {
                cell.textLabel?.text = "Not Authorized"
            }
            
        } else {
            cell.textLabel?.text = "Test"
        }
        
        
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Default Contact
            let picker = CNContactPickerViewController()
            picker.delegate = self
            picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
            
            
            present(picker, animated: true, completion: nil)
            
        } else if indexPath.section == 1 {
            // Home Address
        }
    }
    
}

extension SettingsViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        let contact = contactProperty.contact
        let phoneNumber = contactProperty.value as? CNPhoneNumber
        
        print("\(contact.givenName) - \(phoneNumber?.stringValue ?? "Empty")")
    }
}
