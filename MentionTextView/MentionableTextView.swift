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
    var mentions = Dictionary<String,String>()
    
    var mentionableDelegate: MentionableTextViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        configureAccessoryView()
    }
    
    func configureAccessoryView(){
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:150))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.transform = CGAffineTransform.init(translationX: 0, y: tableView.frame.height)
        tableView.alpha = 0
        tableView.backgroundColor = .gray
        tableView.register(UserCell.nib(), forCellReuseIdentifier: UserCell.identifier())
        autocorrectionType = .no
        inputAccessoryView = tableView
    }
    
    func reloadTableView(){
        (inputAccessoryView as! UITableView).reloadData()
        (inputAccessoryView as! UITableView).separatorStyle = .none
        (inputAccessoryView as! UITableView).pin.height(users.count < 3 ? CGFloat(50 * users.count) : 150)
    }
    
    var query = ""
    
    func refreshMentionDetection() {
        if let accessoryView = inputAccessoryView{
            if let text = text{
                if text[..<cursorPosition()].split(separator: " ").last?.first == "@" && !isAttributedTextAtPositionAnImage() && ((cursorPosition() - 1 != -1) && text[cursorPosition() - 1] != " "){
                    
                    query = String(text[..<cursorPosition()].split(separator: " ").last ?? "")
                    mentionableDelegate?.didUserQuery((query as NSString).replacingOccurrences(of: "@", with: ""))
                    
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
    
    func isAttributedTextAtPositionAnImage() -> Bool {
        var isHasImage = false
        if cursorPosition() - 1 != -1 {
            let range = NSMakeRange(cursorPosition()-1, 1)
            attributedText.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0))
                { (object, range, stop) in
                if object.keys.contains(NSAttributedString.Key.attachment){
                    isHasImage = true
                }
            }
        }
        return isHasImage
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let attributedText = NSMutableAttributedString(attributedString: self.attributedText)
        attributedText.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: attributedText.length))
        let image = user.toImage()
        
        attributedText.insert(NSAttributedString(attachment: NSTextAttachment().apply{
            $0.image = user.toImage()
        }), at: cursorPosition())
        
        attributedText.deleteCharacters(in: NSMakeRange(cursorPosition()-query.count, query.count))
        
        mentions[user] = image?.pngData()?.base64EncodedString(options: .lineLength64Characters)
        mentionableDelegate?.didUserSelected(mentions.map{$0.key})
        
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
        cell.backgroundColor = .gray
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
        
        mentions.forEach{ mention in
            var containsImage = false
            getParts().forEach{ part in
                if let image = part as? UIImage{
                    if mention.value == image.pngData()?.base64EncodedString(options: .lineLength64Characters){
                        containsImage = true
                    }
                }
            }
            if !containsImage{
                mentions.removeValue(forKey: mention.key)
                mentionableDelegate?.didUserSelected(mentions.map{$0.key})
            }
        }
        
        refreshMentionDetection()
    }
    
}

protocol MentionableTextViewDelegate {
    func didUserSelected(_ users:[String])
    func didUserQuery(_ query:String)
}
