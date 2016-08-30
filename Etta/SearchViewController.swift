//
//  SearchViewController.swift
//  Etta
//
//  Created by Ben Murphy on 8/6/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit
import HTMLReader

class SearchViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchToResultsSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewCenterVConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxTopConstraint: NSLayoutConstraint!

    var entries: [HTMLDictionaryEntry] = []

    var coreDataController: CoreDataController!

    // MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        observeKeyboard()
        positionSearchInCenter()
        let a = allRecords()
        a.forEach {
            print("~ ", $0.term)
            if $0.result != nil {
                let entries = Parser(rawContent: $0.result!).parsedContent()
                entries.forEach {
                    print("~ ",$0.descriptionText())
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Methods
    func configureTableView() {
        resultTableView.estimatedRowHeight = 150
        resultTableView.rowHeight = UITableViewAutomaticDimension
    }


    func search(_ term: String) {
        searchBox.text = term
        searchChanged(searchBox)
    }

    func allRecords() -> [Record] {
        do {
            let records = try coreDataController.findRecords()
            return records
        } catch {
            print(error)
            return []
        }
    }



    // MARK: - Actions
    @IBAction func searchChanged(_ sender: UITextField) {

        guard sender.text != nil else {
            return
        }

        var query = SearchQuery(term: sender.text!)


        do {
            try query.search { (response) in
                guard response != nil else { return }
                DispatchQueue.main.async {
                    self.entries = Parser(rawContent: response!).parsedContent()

                    /// If the returned content parses into one or more entries then save the record for future use
                    if self.entries.count != 0 {
                    self.resultTableView.reloadData()
                        query.result = response
                        self.coreDataController.saveRecord(of: query)
                    }
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


}


// MARK: - Table View Protocol Conformance
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EttaResultCell", for: indexPath) as! EttaResultTableViewCell
        let entry = entries[indexPath.item]
        cell.term.text = entry.termText()
        cell.links = entry.linkedText()
        cell.linksList.text = cell.links.joined(separator: ", ")
        cell.entryDescription.attributedText = entry.descriptionWithLinks()

        /// Add gesture recognizer
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.textTapped(_:)))
        cell.entryDescription.addGestureRecognizer(tapEvent)
        return cell
    }
}

// MARK: - Animations
extension SearchViewController {

    func positionSearchInCenter() {
        searchBoxTopConstraint.constant = view.frame.midY - searchBoxHeightConstraint.constant

        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded()
        }
    }

    func pushSearchToTop() {
        searchBoxTopConstraint.constant = 8.0

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }



    func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }


    func keyboardWillShow(notification: NSNotification) {
        pushSearchToTop()
    }


    func keyboardWillHide(notification: NSNotification) {
    }
}






