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
    
    func setAccessoryView(){
        let view = UIStackView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:150))
        view.axis = .vertical
        view.distribution = .fillEqually
        view.addArrangedSubview(UIView().apply{
            $0.backgroundColor = .blue
            $0.onTap{_ in
                let currentText = self.textView.text.getWordWithoutLastMention()
                let currentTextSymbol = currentText.toSymbolic() + "@alvin" + " "
                self.textView.text = currentText + "@alvin" + " "
                self.ranges.append((currentTextSymbol as NSString).range(of: "@alvin"))
                self.refreshAttributedString()
                self.refreshMentionDetection()
            }
        })
        view.addArrangedSubview(UIView().apply{
            $0.backgroundColor = .green
            $0.onTap{_ in
                let currentText = self.textView.text.getWordWithoutLastMention()
                let currentTextSymbol = currentText.toSymbolic() + "@ghifari" + " "
                self.textView.text = currentText + "@ghifari" + " "
                self.ranges.append((currentTextSymbol as NSString).range(of: "@ghifari"))
                self.refreshAttributedString()
                self.refreshMentionDetection()
            }
        })
        view.addArrangedSubview(UIView().apply{
            $0.backgroundColor = .yellow
            $0.onTap{_ in
                let currentText = self.textView.text.getWordWithoutLastMention()
                let currentTextSymbol = currentText.toSymbolic() + "@hafizh" + " "
                self.textView.text = currentText + "@hafizh" + " "
                self.ranges.append((currentTextSymbol as NSString).range(of: "@hafizh"))
                self.refreshAttributedString()
                self.refreshMentionDetection()
            }
        })
        view.transform = CGAffineTransform.init(translationX: 0, y: view.frame.height)
        view.alpha = 0
        view.backgroundColor = .gray
        textView.autocorrectionType = .no
        textView.inputAccessoryView = view
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
