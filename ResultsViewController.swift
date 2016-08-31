//
//  ResultsViewController.swift
//  Etta
//
//  Created by Ben Murphy on 8/30/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!

    var delegate: SearchControllerDelegate!


    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        resultsTableView.dataSource = self
        resultsTableView.estimatedRowHeight = 150
        resultsTableView.rowHeight = UITableViewAutomaticDimension
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Table View Protocol Conformance
extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EttaResultCell", for: indexPath) as! EttaResultTableViewCell
        let entry = delegate.entries[indexPath.item]
        cell.term.text = entry.termText()
        cell.links = entry.linkedText()
        cell.linksList.text = cell.links.joined(separator: ", ")
        cell.entryDescription.attributedText = entry.descriptionWithLinks()

        /// Add gesture recognizer
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(ResultsViewController.textTapped(_:)))
        cell.entryDescription.addGestureRecognizer(tapEvent)
        return cell
    }

    /// When the text view is tapped determine if the tap hit a link.
    /// If so, perform a search using that term.
    ///
    /// - parameter sender: the textview tapped.
    @IBAction func textTapped(_ sender: UITapGestureRecognizer) {
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
        
        delegate.search(tappedTerm)
    }

}

