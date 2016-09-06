//
//  SearchControllerDelegate.swift
//  Etta
//
//  Created by Ben Murphy on 8/30/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation

protocol SearchControllerDelegate {
    var coreDataController: CoreDataController! { get }
    var record: Record? { get set }
    var entries: [HTMLDictionaryEntry] { get set }
    func search(_ term: String)
    func history() -> [Record]
}


extension SearchControllerDelegate {
    func history() -> [Record] {
        do {
            let records = try coreDataController.findRecords()
            return records
        } catch {
            print(error)
            return []
        }
    }

    func favorites() -> [Record] {
        do {
            let records = try coreDataController.favorites()
            return records
        } catch {
            print(error)
            return []
        }
    }
}
