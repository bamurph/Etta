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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchToResultsSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewCenterVConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBoxTopConstraint: NSLayoutConstraint!

    var activeContainedVC: UIViewController?

    /// Add the results, history and favs VCs from the storyboard as child view controllers
    lazy var resultsViewController: ResultsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
        viewController.delegate = self
        self.addViewControllerAsChildViewController(viewController)
        return viewController
    }()

    lazy var historyViewController: HistoryViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        self.addViewControllerAsChildViewController(viewController)
        return viewController

    }()



    var entries: [HTMLDictionaryEntry] = [] {
        didSet {
            resultsViewController.resultsTableView.reloadData()
        }
    }

    var coreDataController: CoreDataController!
    var searchController = SearchController()

    // MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        observeKeyboard()
        positionSearchInCenter()
        configureSearchBox()
        searchController.delegate = self
        revealContainedVC(resultsViewController)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func addViewControllerAsChildViewController(_ viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }

    func revealContainedVC(_ viewController: UIViewController) {
        containerView.subviews.forEach { $0.isHidden = true }
        activeContainedVC = viewController
        activeContainedVC?.view.isHidden = false
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

        guard let term = sender.text?.trim()  else {
            return
        }
        searchController.lookUp(term)
    }

    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        switch activeContainedVC {
        case is ResultsViewController:
            revealContainedVC(historyViewController)
        default:
            return
        }
    }

    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
    }

    func 


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






