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
}

struct DictionaryEntry {
    let term: NSAttributedString
    let description: NSAttributedString
}
