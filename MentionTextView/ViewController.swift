//
//  ViewController.swift
//  MentionTextView
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import UIKit


class ViewController: UIViewController, MentionableTextViewDelegate{
    
    @IBOutlet weak var textView: MentionableTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4
        textView.users = ["Muhammad", "Ghifari", "Yusuf"]
        textView.reloadTableView()
        textView.mentionableDelegate = self

    }
    
    func didUserSelected(_ users: [String]) {
        print("These are the users \(users)")
    }
    
    func didUserQuery(_ query: String) {
        print(query)
    }
    
}
