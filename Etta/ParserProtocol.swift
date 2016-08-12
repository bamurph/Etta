//
//  Parse.swift
//  Etta
//
//  Created by Ben Murphy on 8/10/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation
import HTMLReader

protocol ParserProtocol {
    var rawContent: String { get }
    func parsedContent() -> [HTMLElement]
    func dictionaryEntriesIn(_ source: HTMLNode) -> [HTMLElement]


}

extension ParserProtocol {
    internal func parsedContent() -> [HTMLElement] {
        let document = HTMLDocument(string: rawContent)
        return dictionaryEntriesIn(document)
    }

    internal func dictionaryEntriesIn(_ source: HTMLNode) -> [HTMLDictionaryEntry] {
        let dictionary = source.firstNode(matchingSelector: "#dictionary")
        let terms        = dictionary?.nodes(matchingSelector: "dt") ?? [HTMLElement]()
        let descriptions = dictionary?.nodes(matchingSelector: "dd") ?? [HTMLElement]()
        let entries = Array(zip(terms, descriptions))
            .map { HTMLDictionaryEntry(term: $0.0,
                                       description: $0.1) }
        return entries
    }
}
