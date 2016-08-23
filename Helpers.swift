//
//  Helpers.swift
//  Etta
//
//  Created by Ben Murphy on 8/11/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit

// MARK: - Helper method to return an attributed string from html text
extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil) else { return nil }
        return html
    }
}

// MARK: - Helper method to find ranges of all occurances of a string in another string.
extension NSString {
    /// Extract ranges matching a string recursively
    ///
    /// - parameter string:     the string to match against
    /// - parameter collection: accumulator to collect ranges
    ///
    /// - returns: array of ranges of indexes matching the string
    func ranges(matching string: String, collection: [(NSRange, String)] = [],  offset: Int = 0) -> [(NSRange, String)] {
        let foundRange = (self as NSString).range(of: string)

        guard foundRange.location != NSNotFound else {
            return collection
        }

        let newText = self.substring(from: foundRange.location + foundRange.length) as NSString
        let stringRange = NSMakeRange(foundRange.location + offset, foundRange.length)
        return newText.ranges(matching: string,
                              collection: collection + [(stringRange, string)],
                              offset: offset + foundRange.location + foundRange.length)
    }

    func rangesMatching(_ strings: [String]) -> [(NSRange, String)] {
        return strings
            .flatMap { self.ranges(matching: $0)}
            .reduce([], +)
    }
    
}



