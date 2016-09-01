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
        searchViewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController!
        searchViewController.coreDataController = coreDataController

        historyViewController = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController!



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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    





}
