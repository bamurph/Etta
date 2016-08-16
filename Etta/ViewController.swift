//
//  ViewController.swift
//  Etta
//
//  Created by Ben Murphy on 8/6/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit
import HTMLReader

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var resultTableView: UITableView!

    var entries: [HTMLDictionaryEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func searchChanged(_ sender: UITextField) {
        guard sender.text != nil else {
            return
        }

        let query = SearchQuery(term: sender.text!)

        do {
            try query.search { (response) in
                DispatchQueue.main.async {
                    self.entries = Parser(rawContent: response!).parsedContent()
                    self.resultTableView.reloadData()
                    print(self.entries.count)
                }
            }
        } catch let error {
            print(error)
        }
    }

    func configureTableView() {
        resultTableView.estimatedRowHeight = 150
        resultTableView.rowHeight = UITableViewAutomaticDimension
    }

}


// MARK: - Table View Protocol Conformance
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EttaResultCell", for: indexPath) as! EttaResultTableViewCell
        cell.term.text = entries[indexPath.item].termText()
        cell.links = entries[indexPath.item].linkedText()
        cell.entryDescription.text = entries[indexPath.item].descriptionText()
        print("~", cell.textLabel?.text)
        cell.addLinksToEntryDescription()
        return cell

    }

}

