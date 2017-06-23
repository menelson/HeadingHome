//
//  NewMessageViewController.swift
//  HeadingHome
//
//  Created by Mike Nelson on 6/23/17.
//
//

import UIKit

class NewMessageViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField?
    @IBOutlet weak var bodyTextView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView?.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: add)
    }
    
    private func add() {
        if let title = self.titleTextField?.text,
            let body = self.bodyTextView?.text {
            _ = MessageController.sharedInstance.createMessage(title: title, withBody: body)
        }
    }
}
