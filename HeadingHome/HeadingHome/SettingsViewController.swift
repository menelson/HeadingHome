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
import MapKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    var contactService: ContactService?
    var mapService: LocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.dataSource = self
        tableView?.delegate = self
        
        contactService = ContactService()
        mapService = LocationManager.sharedInstance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView?.reloadData()
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureContactCell() -> String {
        var title = ""
        if !(CNContactStore.authorizationStatus(for: .contacts) == .authorized) {
            title = "Not Authorized"
        } else {
            let contact = contactService?.getContactDefaults()
            if contact?.0 == "" {
                title = "Not Set"
            } else {
                title = (contact?.0)!
            }
        }
        return title
    }
    
    func configureAddressCell() -> String {
        
        if let address = mapService?.getHomeAddress() {
            return address.title!
        }
        return "Not Set"
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
            cell.textLabel?.text = configureContactCell()
        } else if indexPath.section == 1 {
            cell.textLabel?.text = configureAddressCell()
        }
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Default Contact
            contactService?.showContactPicker()
        } else if indexPath.section == 1 {
            // Home Address
            self.performSegue(withIdentifier: "AddressSearchSegue", sender: nil)
        }
    }
    
}
