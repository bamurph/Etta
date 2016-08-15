//
//  EttaResultTableViewCell.swift
//  Etta
//
//  Created by Ben Murphy on 8/15/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit

class EttaResultTableViewCell: UITableViewCell {

    @IBOutlet weak var term: UILabel!
    @IBOutlet weak var entryDescription: UITextView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
