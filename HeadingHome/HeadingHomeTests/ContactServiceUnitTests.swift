//
//  ContactServiceUnitTests.swift
//  HeadingHome
//
//  Created by Mike Nelson on 6/26/17.
//
//

import XCTest
@testable import HeadingHome

class ContactServiceUnitTests: XCTestCase {
    
    var testService: MockContactService?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testService = MockContactService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testService = nil
        
        super.tearDown()
    }
    
    func testSaveDefaults() {
        // Given
        let name = "Test Name",
        number = "234-456-7891"
        
        // When
        testService?.saveContactDefaults(name: name, number: number)
        
        // Then
        XCTAssertTrue((testService?.saved)!)
    }
    
    func testFetchDefaults() {
        // Given
        var defaults: (String, String)
        
        // When
        defaults = (testService?.getContactDefaults())!
        
        // Then
        XCTAssert(defaults.0 == "Test name", "Should equal Test name")
        XCTAssert(defaults.1 == "123-456-7890", "Should equal 123-456-7890")
    }
    
    func testCallingShowPicker() {
        // Given
        
        // When
        testService?.showContactPicker()
        
        // Then
        XCTAssertTrue((testService?.pickerShown)!)
    }
    
}

class MockContactService: ContactService {
    var saved: Bool = false
    var pickerShown: Bool = false
    
    override func showContactPicker() {
         pickerShown = true
    }
    
    override func saveContactDefaults(name: String, number: String) {
        saved = true
    }
    
    override func getContactDefaults() -> (String, String) {
        return ("Test name", "123-456-7890")
    }
}
