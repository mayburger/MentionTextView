//
//  MentionableTextView.swift
//  MentionTextView
//
//  Created by Muhammad Ghifari on 03/08/21.
//

import Foundation
import UIKit
import PinLayout

class MentionableTextView: UITextView, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{

    
    var users:[String] = ["Ghifari", "Alvin", "Adit", "Reydi"]
    var ranges = Dictionary<String,UIImageView>()
    
    var onUserQuery:((String)->())?
    var onUserSelected:(([String])->())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        configureAccessoryView()
    }
    
    func configureAccessoryView(){
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:150))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform.init(translationX: 0, y: tableView.frame.height)
        tableView.alpha = 0
        tableView.backgroundColor = .gray
        tableView.register(UserCell.nib(), forCellReuseIdentifier: UserCell.identifier())
        autocorrectionType = .no
        inputAccessoryView = tableView
    }
    
    func reloadTableView(){
        (inputAccessoryView as! UITableView).reloadData()
    }
    
    func refreshMentionDetection() {
        if let accessoryView = inputAccessoryView{
            if let text = text{
                if text.count != 0 && text.count >= cursorPosition()-1 && text[cursorPosition()-1] == "@" {
                    UIView.animate(withDuration: 0.2){
                        accessoryView.transform = CGAffineTransform.init(translationX: 0, y: 0)
                        accessoryView.alpha = 1
                    }
                } else{
                    UIView.animate(withDuration: 0.2){
                        accessoryView.transform = CGAffineTransform.init(translationX: 0, y: accessoryView.frame.height)
                        accessoryView.alpha = 0
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let attributedText = NSMutableAttributedString(attributedString: self.attributedText)
        attributedText.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: attributedText.length))
        attributedText.insert(NSAttributedString(attachment: NSTextAttachment().apply{
            $0.image = user.toImage()
        }), at: cursorPosition())
        preserveCursorPosition(withChanges: { _ in
            self.attributedText = attributedText
            return .incrementCursor
        })
        self.refreshMentionDetection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier()) as! UserCell
        let title = users[indexPath.row]
        cell.name.text = title
        return cell
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.attributedText == nil {
            textView.attributedText = NSMutableAttributedString(string: textView.text)
        }
        let mutated = NSMutableAttributedString(attributedString: textView.attributedText)
        mutated.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: mutated.length))
        
    
        preserveCursorPosition(withChanges: { _ in
            self.attributedText = mutated
            return .preserveCursor
        })
        
        refreshMentionDetection()
    }
    
    
    
}
