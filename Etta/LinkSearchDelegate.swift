//
//  LinkSearchDelegate.swift
//  Etta
//
//  Created by Ben Murphy on 8/17/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation

/// Protocol for linking to a new search using a string as the query
protocol LinkSearchDelegate {

    /// Perform a search based on a string passed to the delegate
    ///
    /// - parameter term: the term to search for
    func searchFor(_ term: String)
}
