//
//  CommentView.swift
//  MentionTextView
//
//  Created by Muhammad Ghifari on 06/08/21.
//

import Foundation
import UIKit
import PinLayout


class CommentView: UIView, MentionableTextViewDelegate{
    
    var delegate: MentionableTextViewDelegate?
    
    fileprivate lazy var textView: MentionableTextView={
        let view = MentionableTextView()
        view.initialize()
        view.backgroundColor = .gray
        return view
    }()
    
    fileprivate lazy var attachment:UIImageView={
      let view = UIImageView()
        view.backgroundColor = .gray
        return view
    }()
    
    fileprivate lazy var send: UILabel = {
        let view = UILabel()
        view.text = "Send"
        view.font = .systemFont(ofSize: 16)
        view.textColor = UIColor.black
        return view
    }()
    
    var isTextViewEmpty = true
    var isKeyboardOpen = false
    var keyboardHeight = CGFloat(0)
    
    override func layoutSubviews() {
        backgroundColor = .systemGray6
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.borderWidth = 1
        addSubview(attachment)
        addSubview(textView)
        addSubview(send)
        textView.backgroundColor = .white
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4
        
        if isKeyboardOpen {
            pin.left().right().bottom().height(56 + keyboardHeight)
        } else{
            pin.left().right().bottom().height(56 + superview!.safeAreaInsets.bottom)
        }
        
    
        attachment.pin
            .left(16)
            .left(of: textView)
            .width(24)
            .height(24)
        
        if isTextViewEmpty {
            textView.pin
                .top(8)
                .bottom(superview!.pin.safeArea.bottom == CGFloat(0) ? CGFloat(8) : superview!.pin.safeArea.bottom)
                .height(40)
                .right()
                .right(of: attachment)
                .marginHorizontal(16)
            
            send.pin.right(of: superview!).sizeToFit()
        } else{
            send.pin.right(16).sizeToFit()
            textView.pin
                .top(8)
                .bottom(superview!.pin.safeArea.bottom == CGFloat(0) ? CGFloat(8) : superview!.pin.safeArea.bottom)
                .height(40)
                .left(of: send)
                .right(of: attachment)
                .marginHorizontal(16)
        }
        
        
        attachment.pin.vCenter(to: textView.edge.vCenter)
        send.pin.vCenter(to: textView.edge.vCenter)
        
        textView.font = .systemFont(ofSize: 16)
        textView.mentionableDelegate = self
        observeKeyboard()
    }
    
    func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = keyboardFrame.cgRectValue.height - 150
            isKeyboardOpen = true
            UIView.animate(withDuration: 0.3) {
                  self.setNeedsLayout()
                  self.layoutIfNeeded()
            }
//            UIView.animate(withDuration: 1) {
//                self.transform = CGAffineTransform.init(translationX: 0, y: -(keyboardFrame.cgRectValue.height - (150 + self.superview!.safeAreaInsets.bottom)))
//            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        isKeyboardOpen = false
        UIView.animate(withDuration: 0.3) {
              self.setNeedsLayout()
              self.layoutIfNeeded()
        }
    }
    
    func didUserSelected(_ users: [String]) {
        delegate?.didUserSelected(users)
    }
    
    func didUserQuery(_ query: String) {
        delegate?.didUserQuery(query)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        isTextViewEmpty = textView.text.isEmpty
        UIView.animate(withDuration: 0.3) {
              self.setNeedsLayout()
              self.layoutIfNeeded()
        }
    }
    
}
