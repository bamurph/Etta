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
        refreshLog()
        historyTableView.delegate = self
        historyTableView.dataSource = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshLog() {
        log = delegate.history()
        log.reverse()
    }

    


}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return log.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath as IndexPath)
        cell.textLabel?.text = log[indexPath.item].term
        return cell
    }
}
