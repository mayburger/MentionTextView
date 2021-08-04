//
//  String+Extension.swift
//  MentionTextView
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import Foundation


import UIKit

extension String{

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
            return ceil(boundingBox.height)
        }

        func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

            return ceil(boundingBox.width)
        }
    
    
    func toImage() -> UIImage? {
        let name = self
        let width = (name.width(withConstrainedHeight: 14, font: UIFont.systemFont(ofSize: 16)))
        let frame = CGRect(x: 0, y: 0, width: width, height: 14)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.textColor = .blue
         nameLabel.font = UIFont.systemFont(ofSize: 16)
         nameLabel.text = name
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return nil
    }
    
    func getLastWord()-> Substring{
        return self.split(separator: " ").last ?? ""
    }
    
    func getWordWithoutLastMention() -> String {
        let lastIndexOfMention = self.lastIndex(of: "@")
        return String(prefix(upTo: lastIndexOfMention!))
    }
    
    
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
    
    
    func getLastCharacter() -> Character {
        return self.last ?? " "
    }
    
    func stringBefore(_ delimiter: Character) -> String {
           if let index = firstIndex(of: delimiter) {
               return String(prefix(upTo: index))
           } else {
               return ""
           }
       }
       
       func stringAfter(_ delimiter: Character) -> String {
           if let index = firstIndex(of: delimiter) {
               return String(suffix(from: index).dropFirst())
           } else {
               return ""
           }
       }

}
