//
//  UserDistance.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 01/03/2021.
//

import Foundation
class UserDistance {
    /*
        UserDistance class in Server contains:
                      1. user           User
                      2. distance       float
    */
    
    static public let DISTANCE = "distance"
    
    public var wholeUser: WholeUser?
    public var smallUser: SmallUser?
    public var distance: Float?
    public var isWhole: Bool?
    
    init(wholeUser: WholeUser, distance: Float) {
        self.wholeUser = wholeUser
        self.smallUser = nil
        self.distance = distance
        self.isWhole = true
    }
    
    init(smallUser: SmallUser, distance: Float) {
        self.wholeUser = nil
        self.smallUser = smallUser
        self.distance = distance
        self.isWhole = true
    }
    
    init(jsonObject: Any, isWhole: Bool) {
        if let dictionary = jsonObject as? [String: Any] {
            if isWhole {
                self.wholeUser = WholeUser(dictionary: dictionary)
                self.smallUser = nil
            } else {
                self.wholeUser = nil
                self.smallUser = SmallUser(dictionary: dictionary)
            }
            self.isWhole = isWhole
            if let distance = dictionary[UserDistance.DISTANCE] as? Float {
                self.distance = distance
            }
        }
    }
    
    static public func processUserDistancesFromData(data: Data) -> [UserDistance]? {
        var users: [UserDistance] = []
        
        //go in a loop and create users
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let array: [Any] = json as? [Any] {
            for any in array {
                users.append(UserDistance(jsonObject: any, isWhole: false))
            }
        }
        return users
    }
}
