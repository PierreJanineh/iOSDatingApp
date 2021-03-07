//
//  ServerSocket.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 01/03/2021.
//

import Foundation

protocol SocketDelegate: class {
    func socketDataReceived(result: Data)
}

class SocketServer: NSObject {
    
    static private let HOST = "192.168.1.226"
    static private let PORT: UInt32 = 3000
    
    /*MESSAGE*/
    static public let SEND_MESSAGE: UInt8 = 101
    static public let GET_MESSAGES: UInt8 = 102
    static public let GET_MESSAGE: UInt8 = 103
    /*USER*/
    static public let GET_USER_FROM_UID: UInt8 = 120
    static public let GET_SMALL_USER: UInt8 = 121
    static public let GET_CURRENT_USER: UInt8 = 122
    static public let GET_NEARBY_USERS: UInt8 = 123
    static public let GET_NEW_USERS: UInt8 = 124
    static public let GET_USERINFO: UInt8 = 125
    static public let GET_USERDISTANCE: UInt8 = 126
    static public let GET_FAVS: UInt8 = 127
    static public let GET_IMAGES: UInt8 = 128
    static public let ADD_USER: UInt8 = 129
    static public let ADD_FAV: UInt8 = 130
    static public let REM_FAV: UInt8 = 131
    static public let UPDATE_USERINFO: UInt8 = 132
    static public let UPDATE_USER_FIELDS: UInt8 = 133
    /*GEO_POINT*/
    static public let UPDATE_LOCATION: UInt8 = 150
    /*USER_INFO*/
    static public let GET_ALL_ROOMS: UInt8 = 160
    static public let GET_USERS_OF_ROOMS_FOR_USER: UInt8 = 161
    static public let PROFILE_VIEW: UInt8 = 162

    /*SERVER_CODES*/
    static public let OKAY = 200
    static public let READY = 300
    static public let FAILURE = 500
    
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    private let maxReadLength = 20000
    
    public var isOpen: Bool = false
    weak var delegate: SocketDelegate?
    
    override init() {
        super.init()
    }
    
    deinit {
        print("closed")
    }
    
    public func connect() {
        //set up two uninitialized socket streams without automatic memory management
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        //bind read and write socket streams together and connect them to the socket of the host
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           SocketServer.HOST as CFString,
                                           SocketServer.PORT,
                                           &readStream,
                                           &writeStream)
        
        
        //store retained references
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
//        //run a loop
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
//
//        //open flood gates
        inputStream.open()
        outputStream.open()
        
    }
    
    private func closeNetworkConnection() {
        inputStream.close()
        outputStream.close()
        isOpen = false
    }
    
    public func getNewUsers(uid: UInt8!) {
        writeToOutputStream(int: SocketServer.GET_NEW_USERS)
        writeToOutputStream(int: uid)
    }
    
    public func getNearbyUsers(uid: UInt8!) {
        writeToOutputStream(int: SocketServer.GET_NEARBY_USERS)
        writeToOutputStream(int: uid)
    }
    
    public func getFavouriteUsers(uid: UInt8!) {
        writeToOutputStream(int: SocketServer.GET_FAVS)
        writeToOutputStream(int: uid)
    }
    
}
extension SocketServer: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            print("inputStream has something to pass")
            let s = readStringFrom(stream: aStream as! InputStream)
            print(s)
            closeNetworkConnection()
            delegate?.socketDataReceived(result: Data(s!.utf8))
        case .endEncountered:
            print("end of inputStream")
        case .errorOccurred:
            print("error occured")
        case .hasSpaceAvailable:
            print("has space available")
        case .openCompleted:
            isOpen = true
            print("open completed")
        default:
            print("StreamDelegate event")
        }
    }
    
    private func getBufferFrom(stream: InputStream, size: Int) -> UnsafeMutablePointer<UInt8> {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        
        while (stream.hasBytesAvailable) {
            let numberOfBytesRead = self.inputStream.read(buffer, maxLength: size)
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            if numberOfBytesRead == 0 {
                //EOF
                break
            }
        }
        return buffer
    }
    
    private func readDataFrom(stream: InputStream, size: Int) -> Data? {
        let buffer = getBufferFrom(stream: stream, size: size)
        
        return Data(bytes: buffer, count: size)
    }
    
    private func readStringFrom(stream: InputStream, withSize: Int) -> String? {
        print("size: \(withSize)")
        let d = readDataFrom(stream: stream, size: withSize)!
        let s = String(data: d, encoding: .utf8)
//        let buffer = getBufferFrom(stream: stream, size: withSize)
//        let s = String(cString: buffer)
        return s
    }
    
    private func readStringFrom(stream: InputStream) -> String? {
        let len: Int = Int(Int32(readIntFrom(stream: inputStream)!))
        return readStringFrom(stream: stream, withSize: len)
    }
    
    private func readIntFrom(stream: InputStream) -> UInt32? {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        
        let numberOfBytesRead = self.inputStream.read(buffer, maxLength: 4)
        if numberOfBytesRead < 0, let error = stream.streamError {
            print(error)
            return nil
        }
        var int: UInt32 = 0
        let data = NSData(bytes: buffer, length: 4)
        data.getBytes(&int, length: 4)
        int = UInt32(bigEndian: int)
        buffer.deallocate()
        return int
    }
    
    private func readUInt8From(stream: InputStream) -> UInt8? {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
        
        let numberOfBytesRead = self.inputStream.read(buffer, maxLength: 1)
        
        if numberOfBytesRead < 0, let error = stream.streamError {
            print(error)
            return nil
        }
        buffer.deallocate()
        return buffer.pointee
    }
    
    private func writeToOutputStream(string: String){
        let data = string.data(using: .utf8)!
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
            else {
                print("Error joining chat")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    private func writeToOutputStream(int: UInt8){
        let data = int.data
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
            else {
                print("Error joining chat")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
}


