//
//  ViewController.swift
//  MentionTextView
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var textView: MentionableTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4

    }
    
}
