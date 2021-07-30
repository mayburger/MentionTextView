//
//  UITextView+Extension.swift
//  MentionTextView
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import Foundation
import UIKit


extension UITextView{
    func insertAtTextViewCursor(attributedString: NSAttributedString) {
        guard let selectedRange = selectedTextRange else {
            return
        }
        let cursorIndex = offset(from: beginningOfDocument, to: selectedRange.start)
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        mutableAttributedText.insert(attributedString, at: cursorIndex)
        attributedText = mutableAttributedText
    }
}
