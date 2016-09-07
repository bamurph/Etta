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
    var favoritesViewController: FavoritesViewController!
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

        favoritesViewController = {
            let fvc = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController!
            fvc?.delegate = searchViewController
            return fvc
        }()


        /// Add view controllers to pages array and set initial page
        pages = [favoritesViewController, searchViewController, historyViewController]
        //showSearchViewController(completion: nil)
        setViewControllers([searchViewController], direction: .forward, animated: false, completion: nil)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let previousIndex = abs((currentIndex - 1 + pages.count) % pages.count)
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }


    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let firstVC = pendingViewControllers.first else { return }

        switch firstVC {
        case historyViewController:
            DispatchQueue.main.async {
                self.historyViewController.refreshLog()
                self.historyViewController.historyTableView.reloadData()
                self.historyViewController.historyTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
            }
        case favoritesViewController:
            DispatchQueue.main.async {
                self.favoritesViewController.refreshFavorites()
                self.favoritesViewController.favoritesTableView.reloadData()
                self.favoritesViewController.favoritesTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
            }
        default:
            return
        }
    }

    func showSearchViewController(completion: ((Bool) -> Void)?) {
        guard let currentVC = viewControllers?.first else { return }
        guard let svcIndex = pages.index(of: searchViewController) else { return }
        guard let cvcIndex = pages.index(of: currentVC) else { return }
        guard cvcIndex != svcIndex else { return }

        let direction: UIPageViewControllerNavigationDirection = cvcIndex < svcIndex ? .forward : .reverse

        setViewControllers([searchViewController], direction: direction, animated: true, completion: completion)




    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    





}
