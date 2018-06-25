//
//  String+Localization.swift
//  ImagePicker
//
//  Created by Ilker Baltaci on 25.06.18.
//  Copyright © 2018 Ilker Baltaci. All rights reserved.
//

import Foundation


@objc extension NSString {
    
    var localized: String {
        return (self as String).localized
    }
    
    @objc func isEmpty() -> Bool {
        return (self as String).isEmpty
    }
}

extension String {
    func localized(params: String...) -> String {
        let localized = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        return localized
    }
}
