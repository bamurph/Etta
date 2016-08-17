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



    var links: [String] = []
    var delegate: LinkSearchDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func addLinksToEntryDescription() {
        let textWithRanges = entryDescription.text.rangesMatching(links)
        let mutableText = NSMutableAttributedString(string: entryDescription.text)

        // Style Attribute
        mutableText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: Config.fontSize), range: NSRange(location: 0, length: mutableText.length))

        // TODO: - Delegate new search with text of string

        // Set attribute(s) on part of the string
        for link in textWithRanges {
            mutableText.addAttribute("SearchText", value: link.1, range: link.0)
            mutableText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: Config.fontSize)], range: link.0)
        }

        entryDescription.attributedText = mutableText
    }

    func searchFor(_ term: String) {
        delegate?.searchFor(term)
    }

   }

