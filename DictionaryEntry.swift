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

    

}


