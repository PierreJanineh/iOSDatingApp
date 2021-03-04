//
//  Message.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 01/03/2021.
//

import Foundation
class Message {
    /*
        Message class in Server contains:
                    1. uid          int
                    2. to           User
                    3. from         User
                    4. content      String
                    5. timestamp    java.util.Date.Timestamp
                    6. isItMe       boolean
    */
    
    static public let UID = "uid"
    static public let CONTENT = "content"
    static public let TO = "to"
    static public let FROM = "from"
    static public let TIMESTAMP = "timestamp"
    
    public var uid: Int?
    public var to, from: SmallUser
    public var content: String
    public var timestamp: Date
    public var isItFromMe: Bool?
    
    init(content: String, timestamp: Date, to: SmallUser, from: SmallUser) {
        self.content = content
        self.timestamp = timestamp
        self.to = to
        self.from = from
    }
    
    func setIsItFromMe(uid: Int) -> Bool {
        if (to.uid == uid){
            self.isItFromMe = true
            return true
        }else{
            self.isItFromMe = false
            return false
        }
    }
}
