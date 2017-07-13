//
//  MainMessageViewController.swift
//  HeadingHome
//
//  Created by Mike Nelson on 6/19/17.
//
//

import UIKit
import CoreData
import MapKit
import MNPermissionService
import MessageUI

class MainMessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var mapView: MKMapView?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var mapService: LocationManager?
    var selectedMessage: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        initializeFetchedResultsController()
        
        mapService = LocationManager.sharedInstance
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "UserLocationChange"),
                                               object: nil,
                                               queue: nil) {
                                                _ in
                                                
                                                let current = self.mapService?.getCurrentLocation()
                                                self.setUpMaps(location: current!)
        }
        
        mapService?.etaDelegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(!(segue.identifier == "SettingsSegue" || segue.identifier == "NewMessageSegue")) {
            let idx = NSIndexPath(row: (sender as AnyObject).tag, section: 0)
            let message = fetchedResultsController?.object(at: idx as IndexPath) as! Message
            
            if segue.identifier == "MessageDetailSegue" {
                let dest = segue.destination as? MessageDetailViewController
                dest?.message = message
            }
        }
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        
        let nameSort = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [nameSort]
        
        let moc = MessageController.sharedInstance.context
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: moc!,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
        self.fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    // Mark:- IBActions
    
    func didTapSend(_ sender: Any) {
        let idx = NSIndexPath(row: (sender as AnyObject).tag, section: 0)
        let message = fetchedResultsController?.object(at: idx as IndexPath) as! Message
        //print(message.title)
        selectedMessage = message.body
        
        mapService?.getEstimatedTimeHome()
    }
    
    func didTapDetail(_ sender: Any) {
        performSegue(withIdentifier: "MessageDetailSegue", sender: sender)
    }
    
    // Mark:- MapKit Setup
    
    func setUpMaps(location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        
        self.mapView?.setRegion(region, animated: true)
    }
}

//MARK:- ActionCell

class ActionCell: UITableViewCell {
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var sendButton: UIButton?
    @IBOutlet weak var detailButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


//MARK:- TableviewDataSource

extension MainMessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController?.sections else {
            print("No sections")
            return 0
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.contentView.backgroundColor = UIColor.init(red: 57/255, green: 104/255, blue: 243/255, alpha: 1.0)
        header?.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Available Messages"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActionCell = tableView.dequeueReusableCell(withIdentifier: "ActionCell")! as! ActionCell
        
        let message = fetchedResultsController?.object(at: indexPath) as! Message
        
        cell.title?.text = message.title
        
        cell.sendButton?.tag = indexPath.row
        cell.sendButton?.addTarget(self, action: #selector(didTapSend(_:)), for: .touchUpInside)
        
        cell.detailButton?.tag = indexPath.row
        cell.detailButton?.addTarget(self, action: #selector(didTapDetail(_:)), for: .touchUpInside)
        
        return cell
    }
    
}


//MARK:- Tableview Delegate

extension MainMessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let message = fetchedResultsController?.object(at: indexPath) as? Message {
                _ = MessageController.sharedInstance.deleteMessage(message: message)
            }
        }
    }
    
}

//MARK:- FetchedResultsController Delegate

extension MainMessageViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            break
        case .delete:
            tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            break
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView?.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView?.reloadRows(at: [indexPath!], with: .fade)
            break
        case .move:
            tableView?.deleteRows(at: [indexPath!], with: .fade)
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView?.endUpdates()
    }
}

extension MainMessageViewController: ETADelegate {
    func receivedETA(time: Int) {
        if let message = selectedMessage {
            let contact = AppDefaults.sharedInstance.getString(key: appKeys.contactNumber.rawValue)
            
            let controller = MFMessageComposeViewController()
            if MFMessageComposeViewController.canSendText() {
                controller.body = "\(message) I'll be home in \(time) mins."
                controller.recipients = [contact]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}

extension MainMessageViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("Finished")
        controller.dismiss(animated: true, completion: nil)
    }
}
