//
//  Constants.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/6/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

struct JFont {
    static let verySmall = UIFont.systemFont(ofSize: 8)
    static let verySmallBold = UIFont.boldSystemFont(ofSize: 8)
    static let little = UIFont.systemFont(ofSize: 11)
    static let littleMedium = UIFont(name: "HelveticaNeue-Medium", size: 11)!
    static let littleBold = UIFont.boldSystemFont(ofSize: 11)
    static let small = UIFont.systemFont(ofSize: 12)
    static let smallMedium = UIFont(name: "HelveticaNeue-Medium", size: 12)!
    static let smallBold = UIFont.boldSystemFont(ofSize: 12)
    static let medium = UIFont.systemFont(ofSize: 14)
    static let mediumMedium = UIFont(name: "HelveticaNeue-Medium", size: 14)!
    static let mediumBold = UIFont(name: "HelveticaNeue-Bold", size: 14)!
    static let mediumItalic = UIFont(name: "HelveticaNeue-Italic", size: 14)!
    static let large = UIFont.systemFont(ofSize: 16)
    static let largeMedium = UIFont(name: "HelveticaNeue-Medium", size: 16)!
    static let largeBold = UIFont(name: "HelveticaNeue-Bold", size: 16)!
    static let larger = UIFont.systemFont(ofSize: 18)
    static let largerMedium = UIFont(name: "HelveticaNeue-Medium", size: 18)!
    static let largerBold = UIFont(name: "HelveticaNeue-Bold", size: 18)!
    static let extraLarge = UIFont.systemFont(ofSize: 21)
    static let extraLargeMedium = UIFont(name: "HelveticaNeue-Medium", size: 21)!
    static let extraLargeBold = UIFont.boldSystemFont(ofSize: 21)
    static let veryLarge = UIFont.systemFont(ofSize: 23)
    static let veryLargeMedium = UIFont(name: "HelveticaNeue-Medium", size: 23)!
    static let veryLargeBold = UIFont.boldSystemFont(ofSize: 23)
    static let superLarge = UIFont.systemFont(ofSize: 25)
    static let superLargeMedium = UIFont(name: "HelveticaNeue-Medium", size: 25)!
    static let superLargeBold = UIFont.boldSystemFont(ofSize: 25)
    static let huge = UIFont.systemFont(ofSize: 30)
    static let hugeMedium = UIFont(name: "HelveticaNeue-Medium", size: 30)!
    static let hugeBold = UIFont.boldSystemFont(ofSize: 30)
    static let mega = UIFont.systemFont(ofSize: 36)
    static let megaMedium = UIFont(name: "HelveticaNeue-Medium", size: 36)!
    static let megaBold = UIFont.boldSystemFont(ofSize: 36)
}

struct JMetric {
    static let cornerRadius: CGFloat = 6
    static let borderWidth: CGFloat = 1
    static let standardMinSpace: CGFloat = 8
}

struct JColor {
    
    // primary colors
    static let black = UIColor(netHex: 0x000000)
    static let orange = UIColor(netHex: 0xEC7404)
    static let green = UIColor(netHex: 0x52A079)
    static let greenText = UIColor(netHex: 0x6FA249)
    static let greenDark = UIColor(red: 109/255.0, green: 157/255.0, blue: 127/255.0, alpha: 1)
    static let yellow = UIColor(netHex: 0xF1AE2F)
    static let red = UIColor(netHex: 0xB71C1C)
    static let blue = UIColor(netHex: 0x2581C4)
    static let purple = UIColor(netHex: 0x531E6D)
    static let white = UIColor(netHex: 0xFFFFFF)
    static let ice = UIColor(netHex: 0xEFE9E5)
    static let ocher = UIColor(netHex: 0x847E79)
    static let lead = UIColor(netHex: 0x5B5149)
    static let cyan = UIColor(netHex: 0x0084AB)
    static let alternate = UIColor(netHex: 0xFAF8F7) 
    
    // secondary colors
    static let orangeStart = UIColor(netHex: 0xFF7500)
    static let orangeEnd = UIColor(netHex: 0xE79D07)
    
    // derived colors
    static let shadow = lead
    static let textLight = white
    static let text = ocher
    static let textDark = lead
    static let clear = UIColor.clear
    static let enabled = white
    static let disabled = white.withAlphaComponent(0.5)
    static let background = UIColor(netHex: 0x00397E)
    static let foreground = white
    static let timeline = lead
    static let translucent = black.withAlphaComponent(0.8)
    static let border = ice
    static let alternativeForeground = alternate
}

struct JUserDefaultsKeys {
    static let currentMonth = "current_month"
}

struct JConfig {
    static let timeoutInterval = 60.0
}
