//
//  HistoryViewController.swift
//  Etta
//
//  Created by Ben Murphy on 8/30/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    var delegate: SearchControllerDelegate!
    var log = [Record]()

    override func viewDidLoad() {
        super.viewDidLoad()
        log = delegate.history()
    }




}
