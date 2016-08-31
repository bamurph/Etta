//
//  SearchController.swift
//  Etta
//
//  Created by Ben Murphy on 8/30/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation
import CoreData


class SearchController {

    var delegate: SearchControllerDelegate!

    func recordMatching(_ term: String) -> Record? {

        return delegate.history().filter { $0.term == term }.first
    }

    /// Lookup term in coredata log, if not found perform a search
    ///
    /// - parameter term: the term to search for
    func lookUp(_ term: String) {
        if let record = recordMatching(term) {
            DispatchQueue.main.async {
                self.delegate.entries = Parser(rawContent: record.result!).parsedContent()
            }
        } else {
            search(term)
            return
        }

    }

    func search(_ term: String) {
        var query = SearchQuery(term: term)

        do {
            try query.search { (response) in
                guard response != nil else { return }
                DispatchQueue.main.async {
                    self.delegate.entries = Parser(rawContent: response!).parsedContent()
                    /// If the returned content parses into one or more entries then save the record for future use
                    if self.delegate.entries.count != 0 {
                        query.result = response
                        self.delegate.coreDataController?.saveRecord(of: query)
                    }
                }
            }
        } catch let error {
            print(error)
        }
    }
}
