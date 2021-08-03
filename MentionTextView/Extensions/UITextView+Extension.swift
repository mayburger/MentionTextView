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
    func getParts() -> [AnyObject] {
            var parts = [AnyObject]()
            let range = NSMakeRange(0, attributedText.length)
            attributedText.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, stop) in
                if object.keys.contains(NSAttributedString.Key.attachment) {
                    if let attachment = object[NSAttributedString.Key.attachment] as? NSTextAttachment {
                        if let image = attachment.image {
                            parts.append(image)
                        } else if let image = attachment.image(forBounds: attachment.bounds, textContainer: nil, characterIndex: range.location) {
                            parts.append(image)
                        }
                    }
                } else {
                    let stringValue : String = attributedText.attributedSubstring(from: range).string
                    if (!stringValue.trimmingCharacters(in: .whitespaces).isEmpty) {
                        parts.append(stringValue as AnyObject)
                    }
                }
            }
            return parts
        }
}
