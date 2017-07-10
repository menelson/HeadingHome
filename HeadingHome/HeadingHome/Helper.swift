//
//  File.swift
//  HeadingHome
//
//  Created by Mike Nelson on 7/10/17.
//
//

import Foundation
import UIKit

class Helper: NSObject {
    
    static let sharedInstance = Helper()
    
    override init() {
        
    }
    
    func getCurrentViewController() -> UIViewController {
        var viewContoller: UIViewController?
        
        if var currentViewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = currentViewController.presentedViewController {
                currentViewController = presentedViewController
            }
            viewContoller = currentViewController
        }
        
        return viewContoller!
    }

}
