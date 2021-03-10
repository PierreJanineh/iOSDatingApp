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
    
    public var uid, userUid: Int?
    public var imgUrl: String?
    
    init(uid: Int, userUid: Int, imgUrl: String) {
        self.uid = uid
        self.userUid = userUid
        self.imgUrl = imgUrl
    }
    
    init(jsonObject: Any) {
        if let dictionary = jsonObject as? [String: Any] {
            if let uid = dictionary[Image.UID] as? Int {
                self.uid = uid
            }
            if let userUid = dictionary[Image.USER_UID] as? Int {
                self.userUid = userUid
            }
            if let imgUrl = dictionary[Image.IMG_URL] as? String {
                self.imgUrl = imgUrl
            }
        }
    }
    
    /**
     Processes `Data` of JsonObject instance to `[Image]`.
     
     - Parameter data: The `Data` containing JsonObject.
     
     - Returns: `[Image]` from the JsonObject in Data.
     */
    static public func processImagesFromData(data: Data) -> [Image]? {
        var images: [Image] = []
        
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let array: [Any] = json as? [Any] {
            for any in array {
                images.append(Image(jsonObject: any))
            }
        }
        return images
    }
}
