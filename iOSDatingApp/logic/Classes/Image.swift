//
//  Image.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 01/03/2021.
//

import Foundation
class Image {
    
    static public let UID = "uid"
    static public let USER_UID = "userUid"
    static public let IMG_URL = "imgUrl"
    
    public var uid, userUid: Int
    public var imgUrl: String
    
    init(uid: Int, userUid: Int, imgUrl: String) {
        self.uid = uid
        self.userUid = userUid
        self.imgUrl = imgUrl
    }
}
