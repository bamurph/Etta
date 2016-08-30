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

    func queryLog() -> [Record] {
        do {
            let records = try delegate.coreDataController.findRecords()
            return records 
        } catch {
            print(error)
            return []
        }
    }

    func recordMatching(_ term: String) -> Record? {
        print("~ ", queryLog().count, " records found")
        return queryLog().filter { $0.term == term }.first
    }

    /// Lookup term in coredata log, if not found perform a search
    ///
    /// - parameter term: the term to search for
    func lookUp(_ term: String) {
        switch recordMatching(term) {
        case let x where x?.result != nil:
            print("~ Record Match Found for: ", term)
            delegate.entries = Parser(rawContent: x!.result!).parsedContent()
            return
        default:
            print("~ no record match found, searching for: ", term)
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
