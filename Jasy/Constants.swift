//
//  Constants.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/6/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit

class Constants {
    
    struct Font {
        static let VerySmall = UIFont.systemFont(ofSize: 8)
        static let VerySmallBold = UIFont.boldSystemFont(ofSize: 8)
        static let Little = UIFont.systemFont(ofSize: 11)
        static let LittleMedium = UIFont(name: "HelveticaNeue-Medium", size: 11)!
        static let LittleBold = UIFont.boldSystemFont(ofSize: 11)
        static let Small = UIFont.systemFont(ofSize: 12)
        static let SmallMedium = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        static let SmallBold = UIFont.boldSystemFont(ofSize: 12)
        static let Medium = UIFont.systemFont(ofSize: 14)
        static let MediumMedium = UIFont(name: "HelveticaNeue-Medium", size: 14)!
        static let MediumBold = UIFont(name: "HelveticaNeue-Bold", size: 14)!
        static let MediumItalic = UIFont(name: "HelveticaNeue-Italic", size: 14)!
        static let Large = UIFont.systemFont(ofSize: 16)
        static let LargeMedium = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        static let LargeBold = UIFont(name: "HelveticaNeue-Bold", size: 16)!
        static let Larger = UIFont.systemFont(ofSize: 18)
        static let LargerMedium = UIFont(name: "HelveticaNeue-Medium", size: 18)!
        static let LargerBold = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        static let ExtraLarge = UIFont.systemFont(ofSize: 21)
        static let ExtraLargeMedium = UIFont(name: "HelveticaNeue-Medium", size: 21)!
        static let ExtraLargeBold = UIFont.boldSystemFont(ofSize: 21)
        static let VeryLarge = UIFont.systemFont(ofSize: 23)
        static let VeryLargeMedium = UIFont(name: "HelveticaNeue-Medium", size: 23)!
        static let VeryLargeBold = UIFont.boldSystemFont(ofSize: 23)
        static let SuperLarge = UIFont.systemFont(ofSize: 25)
        static let SuperLargeMedium = UIFont(name: "HelveticaNeue-Medium", size: 25)!
        static let SuperLargeBold = UIFont.boldSystemFont(ofSize: 25)
        static let Huge = UIFont.systemFont(ofSize: 30)
        static let HugeMedium = UIFont(name: "HelveticaNeue-Medium", size: 30)!
        static let HugeBold = UIFont.boldSystemFont(ofSize: 30)
        static let Mega = UIFont.systemFont(ofSize: 36)
        static let MegaMedium = UIFont(name: "HelveticaNeue-Medium", size: 36)!
        static let MegaBold = UIFont.boldSystemFont(ofSize: 36)
    }
    
    struct Metric {
        static let cornerRadius: CGFloat = 6.0
        static let borderWidth: CGFloat = 1
    }
    
    struct Color {
        
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
        static let alternate = UIColor(netHex: 0xFAF8F7) // not taken from the design rules PDF but from the prototype PDF
        
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
}
