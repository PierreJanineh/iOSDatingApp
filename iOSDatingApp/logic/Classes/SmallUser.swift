//
//  SmallUser.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 01/03/2021.
//

import Foundation
class SmallUser {
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
    
    public var uid: Int?
    public var username: String?
    public var geoPoint: GeoPoint?
    public var img_url: String?
    
    init(username: String, geoPoint: GeoPoint, img_url: String) {
        self.username = username
        self.geoPoint = geoPoint
        self.img_url = img_url
    }
    
    init(dictionary: Dictionary<String, Any>){
        if let uid = dictionary[WholeCurrentUser.UID] as? Int {
            self.uid = uid
        }
        if let username = dictionary[WholeCurrentUser.USERNAME] as? String {
            self.username = username
        }
        self.geoPoint = GeoPoint(dictionary: dictionary)
        if let img_url = dictionary[WholeCurrentUser.IMG_URL] as? String {
            self.img_url = img_url
        }
    }
}
