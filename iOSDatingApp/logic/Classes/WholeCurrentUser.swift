//
//  WholeCurrentUser.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 01/03/2021.
//

import Foundation
class WholeCurrentUser {
    /*
        User class in Server contains:
                      1. uid            int
                      2. username       String
                      3. geoPoint       GeoPoint
                      4. img_url        String
                      5. favs           ArrayList<Integer>
                      6. chatrooms      ArrayList<Room>
                      7. info           UserInfo
    */
    
    static public let ADD = 1
    static public let REMOVE = 2
    static public let UID = "uid"
    static public let USERNAME = "username"
    static public let IMG_URL = "img_url"
    static public let FAVS = "favs"
    static public let CHAT_ROOMS = "chatRooms"
    static public let INFO = "info"
    static public let USER = "user"
    
    public var uid: Int
    public var username: String
    public var geoPoint: GeoPoint
    public var img_url: String
    public var favs: [Int]
    public var chatRooms: [Room]
    public var info: UserInfo
    
    init(uid: Int, username: String, geoPoint: GeoPoint, img_url: String, favs: [Int], chatRooms: [Room], info: UserInfo) {
        self.uid = uid
        self.username = username
        self.geoPoint = geoPoint
        self.img_url = img_url
        self.favs = favs
        self.chatRooms = chatRooms
        self.info = info
    }
}
