//
//  Search.swift
//  Etta
//
//  Created by Ben Murphy on 8/6/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation
import HTMLReader

protocol SearchProtocol {
    var term: String { get }
    var result: String? { get set }
    func search(_ completionHandler: @escaping (_ response: String?) -> Void) throws
    func cancelPreviousSearches()
}

extension SearchProtocol {

    /// Performs a search at EtymOnline
    ///
    /// - parameter text: the text to search for
    /// - parameter completionHandler: function to execute once the task is completed
    internal func search (_ completionHandler: @escaping (_ response:String?) -> Void) throws {

        /// Cancel outstanding requests
        cancelPreviousSearches()

        /// Prepare the session and request objects
        guard let requestURL = URL(string: Config.eoURL)?.appendingPathComponent(self.term) else {
            throw SearchError.invalidURL
        }

        let request = URLRequest(url: requestURL)
        let session = URLSession.shared

        /// Define the task to perform - passed in as a closure
        let task : URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in

            /// Guard against missing data or an error
            guard let data = data else {
                print("~ No data returned")
                return
            }
            guard error == nil else {
                print(error)
                return
            }

            /// Define the response object & set response property
            let response = String(data: data, encoding: String.Encoding.utf8)

            completionHandler(response)
        }
        task.resume()
    }

    /// Cancel prior search(es). Use at the beginning of a new search.
    func cancelPreviousSearches() {
        let session = URLSession.shared
        session.getAllTasks { (tasks) in
            guard tasks.count > 0 else { return }
            tasks.forEach({ (task) in
                task.cancel()
            })
        }
    }
}



