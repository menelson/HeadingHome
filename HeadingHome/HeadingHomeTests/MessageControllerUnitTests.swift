//
//  MessageControllerUnitTests.swift
//  HeadingHome
//
//  Created by Mike Nelson on 6/19/17.
//
//

import XCTest
import CoreData

@testable import HeadingHome

class MessageControllerUnitTests: XCTestCase {
    
    var controller: MessageController?
    
    override func setUp() {
        super.setUp()
        
        controller = MessageController.sharedInstance
        controller?.context = setUpInMemoryCoreDateContext()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        controller = nil
        
        super.tearDown()
    }
    
    /*
     * Technique is from https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/
     */
    func setUpInMemoryCoreDateContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    func testControllerInit() {
        // Given
        let testController: MessageController?
        
        // When
        testController = MessageController.sharedInstance
        
        // Then
        XCTAssertNotNil(testController)
        XCTAssertNotNil(testController?.context!)
        
    }
    
    func testControllerCreate() {
        // Given
        let title = "Test Title"
        let body = "Test Message"
        
        // When
        let message = controller?.createMessage(title: title, withBody: body)
        
        // Then
        XCTAssertTrue(message?.title == title)
        XCTAssertTrue(message?.body == body)
    }
    
    func testControllerUpdate() {
        // Given
        let newTitle = "New Title"
        let message = controller?.createMessage(title: "Test", withBody: "Body")
        
        // When
        message?.title = newTitle
        let updated = controller?.updateMessage(message: message!)
        
        // Then
        XCTAssertTrue(updated!)
        XCTAssertTrue(newTitle == message?.title)
    }
    
    func testControllerDelete() {
        // Given
        let message = controller?.createMessage(title: "Test", withBody: "Body")
        
        // When
        let deleted = controller?.deleteMessage(message: message!)
        
        // Then
        XCTAssertTrue(deleted!)
    }
}
