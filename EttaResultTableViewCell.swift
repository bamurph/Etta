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
    @IBOutlet weak var rangeCount: UILabel!

    var links: [String] = []


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}

