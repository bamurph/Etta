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
    func parsedContent() -> String

}

extension ParserProtocol {
    internal func parsedContent() -> String {

    }
}

struct Parser: ParserProtocol {
    let rawContent: String
}
