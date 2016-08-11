//
//  Errors.swift
//  Etta
//
//  Created by Ben Murphy on 8/11/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation

enum SearchError: Error {
    case invalidURL
    case noDataReturned
    case urlSessionDataTaskError(error: Error)
}
