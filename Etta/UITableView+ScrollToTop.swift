//
//  UITableView+ScrollToTop.swift
//  Etta
//
//  Created by Ben Murphy on 9/12/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit

// MARK: - Prevent crash if table view is loaded and scrolled to a nonexistent row
extension UITableView {

    /// Scroll to the top of the table view. If there are zero rows then use an indexPath with NSNotFound for the row (not sure if there is any cost or benefit for including this code at all)
    // TODO: - Review UITableView scrollToRow - should I bother with the 0 case?

    func scrollToTop() {
        let indexPath: IndexPath
        switch self.numberOfRows(inSection: 0) {
        case 0:
            indexPath = IndexPath(row: NSNotFound, section: 0)
        default:
            indexPath = IndexPath.init(row: 0, section: 0)
        }
        scrollToRow(at: indexPath, at: .top, animated: false)
    }
}
