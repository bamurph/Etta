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
    var entries: [HTMLDictionaryEntry] { get set }
    
}
