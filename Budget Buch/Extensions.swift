//
//  Extensions.swift
//  Credit Agent
//
//  Created by Benjamin Jakob on 30.04.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

extension UIColor {
    static var appleBlue = UIColor(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
    static var appThemeColor = UIColor(red: 44.0/255, green: 62.0/255, blue: 80.0/255, alpha: 1.0)
//    static var appThemeColor = UIColor(red: 94.0/255, green: 32.0/255, blue: 40.0/255, alpha: 1.0)
}

extension DateFormatter {
    
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")
        return formatter
    }()
    
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM")
        return formatter
    }()
    
    static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy")
        return formatter
    }()
    
}

extension NumberFormatter {
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}


