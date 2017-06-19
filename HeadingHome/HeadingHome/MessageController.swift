//
//  MessageController.swift
//  HeadingHome
//
//  Created by Mike Nelson on 6/19/17.
//
//

import Foundation
import CoreData

class MessageController {
    
    var context: NSManagedObjectContext?
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        
        persistentContainer.loadPersistentStores() {
            (storeDescrpition, error) in
            
            if let error = error {
                fatalError("Failed to load with \(error)")
            }
        }
        
        context = persistentContainer.newBackgroundContext()
    }
    
    func save() -> Bool {
        if (context?.hasChanges)! {
            do {
                try context?.save()
            } catch {
                print("Unable to save with \(error)")
                return false
            }
        }
        
        return true
    }
    
    func createMessage(title: String, withBody body: String) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: (context)!) as! Message
        
        message.title = title
        message.body = body
        
        let saved = save()
        
        if !saved {
            print("Message not saved")
        }
        
        return message
    }
    
    func updateMessage(message: Message) -> Bool {
        let saved = save()
        
        if !saved {
            print("Message not updated")
            return false
        }
        return true
    }
    
    func deleteMessage(message: Message) -> Bool {
        
        context?.delete(message)
        
        let saved = save()
        
        if !saved {
            print("Message not deleted")
            return false
        }
        return true
        
    }
    
}
