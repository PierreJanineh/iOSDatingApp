//
//  Constants.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 05/03/2021.
//

import UIKit
/**
 Constants of the App
 
 ## Types:
 ~~~
 1. Colors: UIColor
 2. Strings: String
 ~~~
 */
 class Constants {
    
    /**
     Colors Constants to used withind the app.
     */
    class Colors {
        static public var PRIMARY_COLOR = UIColor.brown,
                          SECONDARY_COLOR = UIColor.yellow,
                          BACKROUND_COLOR = UIColor.black,
                          FOREGROUND_COLOR = UIColor.white
    }
    
    /**
     String constants used within the app.
     */
    class Strings {
        static public var MAIN_APP_TITLE = "Dating App",
                          FAV_FRAGMENT = "Favourites",
                          DASH_FRAGMENT = "Dashboard",
                          CHAT_FRAGMENT = "Chat"
    }
}
