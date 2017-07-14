//
//  MessageDetailViewController.swift
//  HeadingHome
//
//  Created by Mike Nelson on 6/24/17.
//
//

import UIKit

class MessageDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField?
    @IBOutlet weak var bodyTextView: UITextView?
    var message: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView?.layer.borderWidth = 1
        
        if let title = message?.title,
           let body = message?.body {
            titleTextField?.text = title
            bodyTextView?.text = body
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: update)
    }
    
    private func update() {
        if let title = titleTextField?.text,
            let body = bodyTextView?.text {
            message?.title = title
            message?.body = body
        }
        _ = MessageController.sharedInstance.updateMessage(message: message!)
    }

}
