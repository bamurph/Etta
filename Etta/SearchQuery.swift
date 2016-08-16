//
//  SearchQuery.swift
//  Etta
//
//  Created by Ben Murphy on 8/10/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

/// A basic search query - init with a search term
struct SearchQuery: SearchProtocol {

    let term: String
    var result: String? = nil

    init(term: String) {
        self.term = term
        self.result = nil
    }
}
