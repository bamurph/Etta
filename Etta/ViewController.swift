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

    func configureTableView() {
        resultTableView.estimatedRowHeight = 150
        resultTableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK:  Actions
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

    /// When the text view is tapped determine if the tap hit a link.
    /// If so, perform a search using that term.
    ///
    /// - parameter sender: the textview tapped.
    @IBAction func textTapped(_ sender: UITapGestureRecognizer) {
        print("Tap!")
        guard let textView = (sender.view as? UITextView) else {
            return
        }

        let layoutManager = textView.layoutManager
        var location: CGPoint = sender.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top

        let charIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        guard charIndex < textView.textStorage.length else {
            return
        }

        var range = NSRange(location: 0, length: 0)

        guard (textView.attributedText?.attribute("SearchText", at: charIndex, effectiveRange: &range) as? NSString) != nil else {
            return
        }

        let tappedTerm = (textView.attributedText.string as NSString).substring(with: range)

        search(tappedTerm)
    }

    func search(_ term: String) {
        searchBox.text = term
        searchChanged(searchBox)
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
        cell.linksList.text = cell.links.joined(separator: ", ") 
        cell.entryDescription.text = entries[indexPath.item].descriptionText()
        cell.addLinksToEntryDescription()
        return cell

    }
}




