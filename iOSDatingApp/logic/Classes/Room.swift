//
//  Room.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 01/03/2021.
//

import Foundation
class Room {
    /*
        Room class in Server contains:
                      1. uid            int
                      2. seenBy         int[]
                      3. messages       int[]
                      4. recipients     int[]
                      5. lastMessage    Message
    */
    
    static public let UID = "uid"
    static public let SEEN_BY = "seenBy"
    static public let MESSAGES = "messages"
    static public let RECIPIENTS = "recipients"
    static public let LAST_MESSAGE = "lastMessage"
    
    public var uid: Int?
    public var seenBy, messages, recipients: [Int]
    public var lastMessage: Message
    
    init(seenby: [Int], messages: [Int], recipients: [Int], lastMessage: Message) {
        self.seenBy = seenby
        self.messages = messages
        self.recipients = recipients
        self.lastMessage = lastMessage
    }
}
