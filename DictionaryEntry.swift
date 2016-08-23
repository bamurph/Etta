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

    func descriptionWithLinks() -> NSAttributedString {
        let textWithRanges = descriptionText().rangesMatching(linkedText())
        let mutableText = NSMutableAttributedString(string: descriptionText())

        let ranges = textWithRanges.map { "\($0.0.location) - \($0.0.length) \n"}
        print("~", ranges)

        // Style Attribute
        mutableText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: Config.fontSize), range: NSRange(location: 0, length: mutableText.length))

        // TODO: - Delegate new search with text of string

        // Set attribute(s) on part of the string
        for link in textWithRanges {
            mutableText.addAttribute("SearchText", value: link.1, range: link.0)
            mutableText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: Config.fontSize)], range: link.0)
        }

        return mutableText
    }

}


