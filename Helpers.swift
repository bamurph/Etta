//
//  Helpers.swift
//  Etta
//
//  Created by Ben Murphy on 8/11/16.
//  Copyright © 2016 Constellation Software. All rights reserved.
//

import UIKit

// MARK: - Helper method to return an attributed string from html text
extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil) else { return nil }
        return html
    }
}
