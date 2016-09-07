//
//  TableViewDelegate+Search.swift
//  Etta
//
//  Created by Ben Murphy on 9/7/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import Foundation
import UIKit


extension UITableViewDelegate where Self: UIViewController  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, using delegate: SearchControllerDelegate) {
        guard let pvc = parent as? EttaPageViewController else { return }
        guard let term = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
        pvc.showSearchViewController { (completed: Bool) in
            delegate.search(term)
        }
    }
}
