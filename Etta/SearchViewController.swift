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

    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchToResultsSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxTopConstraint: NSLayoutConstraint!


    var resultsViewController: ResultsViewController!
    var coreDataController: CoreDataController!
    var searchController = SearchController()
    var record: Record?
    var searchBoxCentered = true

    var entries: [HTMLDictionaryEntry] = [] {
        didSet {
            resultsViewController.resultsTableView.reloadData()
        }
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.delegate = self
        observeKeyboard()
        configureSearchBox()
        positionSearchInCenter()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Methods

    func configureSearchBox() {
        searchBox.clearButtonMode = .always
    }

    func search(_ term: String) {
        searchBox.text = term
        searchChanged(searchBox)
    }

    // MARK: - Actions
    @IBAction func searchChanged(_ sender: UITextField) {
        if searchBoxCentered == true { pushSearchToTop() }
        guard let term = sender.text?.trim()  else {
            return
        }
        searchController.lookUp(term)
    }

    // MARK: - Segue(s)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc =
            segue.destination as? ResultsViewController,
            segue.identifier == "EmbedSegue" {
            resultsViewController = vc
            vc.delegate = self
        }
    }
}



// MARK: - Animations
extension SearchViewController {

    func positionSearchInCenter() {
        searchBoxTopConstraint.constant = view.frame.midY - searchBoxHeightConstraint.constant
        searchBoxCentered = true
        UIView.animate(withDuration: 0.0) {
            self.view.layoutIfNeeded()
        }
    }

    func pushSearchToTop() {
        searchBoxTopConstraint.constant = 8.0
        searchBoxCentered = false
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






