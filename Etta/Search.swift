//
//  Search.swift
//  Etta
//
//  Created by Ben Murphy on 8/6/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation

protocol SearchProtocol {
    var term: String { get }
    var result: String? { get set }
    func search(_ text: String, completionHandler: ()-> Void) -> String?
}

extension SearchProtocol {

    /// Performs a search at EtymOnline
    ///
    /// - parameter text: the text to search for
    internal func search(_ text: String, completionHandler: () -> Void) -> String? {

        /// Prepare the session and request objects
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: Config.eoURL)!)
        var searchResult: String?
        
        /// Define the task to perform - passed in as a closure
        let task : URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in

            /// Guard against missing data or an error
            guard let data = data else {
                print("No data returned")
                return
            }
            guard error == nil else {
                print(error)
                return
            }

            /// Define the response object
            let response = String(data: data, encoding: String.Encoding.utf8)
            searchResult = response!
            completionHandler()
        }
        task.resume()
        return searchResult
    }
}

struct SearchQuery: SearchProtocol {
    let term: String
    var result: String? = nil
}
