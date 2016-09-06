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
        cell.delegate = self
        cell.term.text = entry.termText()
        cell.links = entry.linkedText()
        cell.linksList.text = cell.links.joined(separator: ", ")
        cell.entryDescription.attributedText = entry.descriptionWithLinks()
        cell.favoriteButton.isSelected = delegate.record?.favorite ?? false
        /// Add gesture recognizer
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(ResultsViewController.textTapped(_:)))
        cell.entryDescription.addGestureRecognizer(tapEvent)
        return cell
    }
}

extension ResultsViewController: Favoritable {
    func toggleFavorite() {
        guard let record = delegate.record else { return }
        record.favorite = !record.favorite
        
        delegate.coreDataController.saveContext()
    }
}
