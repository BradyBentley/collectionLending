//
//  DateExtension.swift
//  collectionLending
//
//  Created by Brady Bentley on 2/12/19.
//  Copyright © 2019 bradybentley. All rights reserved.
//

import Foundation

extension Date {
    var asPrettyString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
