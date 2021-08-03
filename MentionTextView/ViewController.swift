//
//  ViewController.swift
//  MentionTextView
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import UIKit
import RxCocoa

class ViewController: UIViewController {
    
    var ranges = Array<NSRange>()
    var currentRangeCount = 0
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4
        textView.delegate = self
        
        
        setAccessoryView()
    }
    
    let users = ["Ghifari","Alvin","Hafidzh","Aditya", "Steve"]
    
    func setAccessoryView(){
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:150))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform.init(translationX: 0, y: tableView.frame.height)
        tableView.alpha = 0
        tableView.backgroundColor = .gray
        tableView.register(UserCell.nib(), forCellReuseIdentifier: UserCell.identifier())
        textView.autocorrectionType = .no
        textView.inputAccessoryView = tableView
    }
    
    func refreshAttributedString() {
        if let text = self.textView.text{
            let attributedString = NSMutableAttributedString.init(string: String(text))
            self.ranges.forEach{
                if text.count >= $0.location + $0.length{
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: $0)
                }
            }
            self.textView.attributedText = attributedString
        }
    }
    
    func refreshMentionDetection() {
        if let accessoryView = self.textView.inputAccessoryView{
            if let text = self.textView.text{
                if text.getLastWord().contains("@") && text.getLastCharacter() != " " && !isLastWordAMention(text: text){
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
    
    func isLastWordAMention(text:String)-> Bool{
        var isMention = false
        self.ranges.forEach{
            if text.count == $0.location + $0.length{
                isMention = true
            }
        }
        return isMention
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentText = self.textView.text.getWordWithoutLastMention()
        let user = users[indexPath.row]
        let currentTextSymbol = currentText.toSymbolic() + "@\(user)" + " "
        self.textView.text = currentText + "@\(user)" + " "
        self.ranges.append((currentTextSymbol as NSString).range(of: "@\(user)"))
        self.refreshAttributedString()
        self.refreshMentionDetection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier()) as! UserCell
        let title = users[indexPath.row]
        cell.name.text = title
        return cell
    }
}

extension ViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if let text = self.textView.text{
            
            self.ranges.forEach{
                if !(text.count >= $0.location + $0.length){
                    self.ranges.remove(at: self.ranges.firstIndex(of: $0)!)
                    if let lastIndex = self.textView.text.lastIndex(of: "@"){
                        self.textView.text = String(self.textView.text.prefix(upTo: lastIndex)) + "@"
                    }
                }
            }
            refreshAttributedString()
            refreshMentionDetection()
        }
    }
}
