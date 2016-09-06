//
//  EttaResultTableViewCell.swift
//  Etta
//
//  Created by Ben Murphy on 8/15/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit
import Foundation

class EttaResultTableViewCell: UITableViewCell {

    @IBOutlet weak var term: UILabel!
    @IBOutlet weak var entryDescription: UITextView!
    @IBOutlet weak var linksList: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    var delegate: Favoritable?
    var links: [String] = []


    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.setTitle(Config.favoriteStar[0], for: .normal)
        favoriteButton.setTitle(Config.favoriteStar[1], for: .selected)
        favoriteButton.setTitleColor(.darkGray, for: .selected)
        favoriteButton.setTitleColor(.blue, for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func toggleFavorite(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.isSelected {
        case true:
            print("~ \(term) is favorited!")
        default:
            print("~ \(term) is not favorited!")
        }
        delegate?.toggleFavorite()
    }
}
