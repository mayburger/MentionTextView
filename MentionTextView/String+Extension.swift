//
//  String+Extension.swift
//  MentionTextView
//
//  Created by Muhammad Ghifari on 29/07/21.
//

import Foundation


extension String{

    
    func getLastWord()-> Substring{
        return self.split(separator: " ").last ?? ""
    }
    
    func getWordWithoutLastMention() -> String {
        let lastIndexOfMention = self.lastIndex(of: "@")
        return String(prefix(upTo: lastIndexOfMention!))
    }
    
    func toSymbolic() -> String{
        var newString = ""
        for i in self {
            newString += ">"
        }
        return newString
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
