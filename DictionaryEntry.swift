//
//  DictionaryEntry.swift
//  Etta
//
//  Created by Ben Murphy on 8/12/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation
import HTMLReader

struct HTMLDictionaryEntry {
    let term: HTMLElement
    let description: HTMLElement

    func linkedText() -> [String] {
        return description.nodes(matchingSelector: "a").map { $0.textContent}
    }

    func ranges() -> [(NSRange, String)] {
        return descriptionText().rangesMatching(linkedText())
    }

    func termText() -> String {
        return term.textContent
    }

    func descriptionText() -> String {
        return description.textContent
    }

    /// Style the raw string description
    ///
    /// - returns: a nsmutableattributedstring with appropriate styling
    func styledDescription() -> NSMutableAttributedString {
        //Setup for styling attributes
        let mutableText = NSMutableAttributedString(string: descriptionText())
        let textRange = NSRange(location: 0, length: mutableText.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Config.fontSize * 1.2

        // Add Attributes
        mutableText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: Config.fontSize), range: textRange)
        mutableText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: textRange)

        return mutableText
    }


    /// Proper output for use in view
    ///
    /// - returns: A NSAttributedString with the proper styling and links
    func descriptionWithLinks() -> NSAttributedString {
        /// Setup for styling attributes
        let textWithRanges = descriptionText().rangesMatching(linkedText())
        let mutableText = styledDescription()

        // Set attribute(s) on links in the string
        for link in textWithRanges {
            mutableText.addAttribute("SearchText", value: link.1, range: link.0)
            mutableText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: Config.fontSize)], range: link.0)
            mutableText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: link.0)
            mutableText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: link.0)
        }

        return mutableText
    }



}


