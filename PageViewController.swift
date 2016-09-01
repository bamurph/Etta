//
//  PageViewController.swift
//  Etta
//
//  Created by Ben Murphy on 8/31/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pages = [UIViewController]()
    var resultsViewController: ResultsViewController!
    var historyViewController: HistoryViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        resultsViewController = storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController!
        historyViewController = storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController!
        pages.append(resultsViewController as UIViewController)
        pages.append(historyViewController as UIViewController)
        setViewControllers([resultsViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
