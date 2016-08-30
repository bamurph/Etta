//
//  SearchViewController.swift
//  Etta
//
//  Created by Ben Murphy on 8/6/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit
import HTMLReader

class SearchViewController: UIViewController, SearchControllerDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchToResultsSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewCenterVConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxTopConstraint: NSLayoutConstraint!

    var entries: [HTMLDictionaryEntry] = [] {
        didSet {
            self.resultTableView.reloadData()
        }
    }

    var coreDataController: CoreDataController!
    var searchController = SearchController()

    // MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        observeKeyboard()
        positionSearchInCenter()
        searchController.delegate = self

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


    // MARK: - Actions
    @IBAction func searchChanged(_ sender: UITextField) {

        guard let term = sender.text  else {
            return
        }
        searchController.search(term)
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






