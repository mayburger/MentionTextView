//
//  ViewController.swift
//  MentionTextView
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import UIKit
import PinLayout

class ViewController: UIViewController, MentionableTextViewDelegate{
    
//    fileprivate lazy var textView: MentionableTextView={
//        let view = MentionableTextView()
//        view.initialize()
//        view.backgroundColor = .gray
//        return view
//    }()
    
    fileprivate lazy var commentView:CommentView={
        let view = CommentView()
        return view
    }()

    
    override func viewDidLoad() {
        configureViews()
        view.onTap { UITapGestureRecognizer in
            self.commentView.endEditing(true)
        }
    }
    
    func configureViews() {
        view.addSubview(commentView)
    }
    
    func didUserSelected(_ users: [String]) {
        
    }
    
    func didUserQuery(_ query: String) {

    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
}
