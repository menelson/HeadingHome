//
//  MainMessageViewController.swift
//  HeadingHome
//
//  Created by Mike Nelson on 6/19/17.
//
//

import UIKit
import CoreData

class MainMessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    @IBAction func didTapAdd(_ sender: Any) {
        
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        
        let nameSort = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [nameSort]
        
        let moc = MessageController().context
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc!, sectionNameKeyPath: "title", cacheName: nil)
        
        self.fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
}


extension MainMessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController?.sections else {
            fatalError("No sections")
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.fetchedResultsController?.sections?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ActionCell")!
        
        let message = fetchedResultsController?.object(at: indexPath) as! Message
        
        cell.textLabel?.text = message.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.contentView.backgroundColor = UIColor.init(red: 57/255, green: 104/255, blue: 243/255, alpha: 1.0)
        header?.textLabel?.textColor = UIColor.white
    }
    
}

extension MainMessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let message = fetchedResultsController?.object(at: indexPath) as? Message {
                _ = MessageController().deleteMessage(message: message)
            }
        }
    }
    
}

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
