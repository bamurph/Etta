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

    internal func dictionaryEntriesIn(_ source: HTMLNode) -> [HTMLElement] {
        return source.nodes(matchingSelector: "#dictionary")
    }
}
