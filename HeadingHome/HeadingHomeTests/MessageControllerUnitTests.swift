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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        let controller: MessageController?
        
        // When
        controller = MessageController()
        
        // Then
        XCTAssertNotNil(controller)
        XCTAssertNotNil(controller?.context!)
    }
    
    func testControllerCreate() {
        // Given
        let controller = MessageController()
        controller.context = setUpInMemoryCoreDateContext()
        let title = "Test Title"
        let body = "Test Message"
        
        // When
        let message = controller.createMessage(title: title, withBody: body)
        
        // Then
        XCTAssertTrue(message.title == title)
        XCTAssertTrue(message.body == body)
    }
}
