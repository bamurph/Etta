//
//  EttaPageViewController.swift
//  Etta
//
//  Created by Ben Murphy on 9/1/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit

class EttaPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pages = [UIViewController]()
    var searchViewController: SearchViewController!
    var historyViewController: HistoryViewController!
    var coreDataController: CoreDataController!

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self

        /// instantiate view controllers
        searchViewController = {
            let svc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController!
            svc?.coreDataController = coreDataController
            return svc
        }()


        historyViewController = {
            let hvc = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController!
            hvc?.delegate = searchViewController
            return hvc
        }()


        /// Add view controllers to pages array and set initial page
        pages = [searchViewController, historyViewController]
        setViewControllers([searchViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)

    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if pendingViewControllers.first == historyViewController {
            DispatchQueue.main.async {
                self.historyViewController.refreshLog()
                self.historyViewController.historyTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    





}
