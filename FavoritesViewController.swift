//
//  FavoritesViewController.swift
//  Etta
//
//  Created by Ben Murphy on 9/6/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favoritesTableView: UITableView!

    var delegate: SearchControllerDelegate!
    var favorites = [Record]()

    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshFavorites() {
        favorites = delegate.favorites()
        favorites.reverse()
    }

}



extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath as IndexPath)
        cell.textLabel?.text = favorites[indexPath.item].term
        return cell
    }
}
