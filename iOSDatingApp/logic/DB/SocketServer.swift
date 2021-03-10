//
//  ServerSocket.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 01/03/2021.
//

import Foundation

protocol SocketDelegate: class {
    /**
     Called when `StreamDelegate` calls `stream(,eventCode)` with `.hasBytesAvailable` after all bytes have been read into a `Data` instance.
     
     - Parameter result: `Data` result from InputStream.
     */
    func socketDataReceived(result: Data?)
    
    /**
     Called when `StreamDelegate` calls `stream(,eventCode)` with `.hasBytesAvailable` after all bytes have been read into a `Data` instance and it was nil.
     */
    func receivedNil()
}

class SocketServer: NSObject {
    
    static private let HOST = "104.198.212.189"
//    static private let HOST = "192.168.1.227"
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
    
    public var isOpen: Bool = false
    weak var delegate: SocketDelegate?
    
    override init() {
        super.init()
    }
    
    deinit {
        print("closed")
    }
    
    /**
     Connects to Server Socket.
     
     ## Steps in method:
     1. Sets delegate to `self`.
     2. Opens `InputStream` and `OutputStream`.
     */
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
    
    /**
     Closes `InputStream` and `OutputStream` after finishing reading the Data from InputStream.
     */
    private func closeNetworkConnection() {
        inputStream.close()
        outputStream.close()
        isOpen = false
    }
    
    /**
     A private global function for all methods (writing `serverCode` + `anotherInt` to `outputStream`) to use to communicate with the server.
     
     - Parameter serverCode: The static field for this function.
     
     - Parameter int: The other int willing to write to `outputStream`.
     */
    private func getFromServerWithAnInt(serverCode: UInt8, int: UInt8) {
        writeToOutputStream(int: serverCode)
        writeToOutputStream(int: int)
    }
    
    /**
     Sends a request to the server to get `[UserDistance]` of nearby users according to the current user's `GeoPoint`.
     
     - Parameter uid: The current user uid.
     */
    public func getNewUsers(uid: UInt8!) {//will request a Json of [UserDistance]
        getFromServerWithAnInt(serverCode: SocketServer.GET_NEW_USERS, int: uid)
    }
    
    /**
     Sends a request to the server to get `[UserDistance]` of nearby users according to the current user's `GeoPoint`.
     
     - Parameter uid: The current user uid.
     */
    public func getNearbyUsers(uid: UInt8!) {//will request a Json of [UserDistance]
        getFromServerWithAnInt(serverCode: SocketServer.GET_NEARBY_USERS, int: uid)
    }
    
    /**
     Sends a request to the server to get `[UserDistance]` of faveourite users of the current user.
     
     - Parameter uid: The current user uid.
     */
    public func getFavouriteUsers(uid: UInt8!) {//will request a Json of [UserDistance]
        getFromServerWithAnInt(serverCode: SocketServer.GET_FAVS, int: uid)
    }
    
    /**
     Sends a request to the server to get `[Image]`.
     
     - Parameter uid: The user uid Images requested belong to.
     */
    public func getImagesForUser(uid: UInt8!) {//will request a Json of [String]
        getFromServerWithAnInt(serverCode: SocketServer.GET_IMAGES, int: uid)
    }
    
    /**
     Sends a request to the server to get `UserInfo`.
     
     - Parameter uid: The user uid for whose info is requested.
     */
    public func getUserInfo(uid: UInt8!) {//will request a Json object of UserInfo
        getFromServerWithAnInt(serverCode: SocketServer.GET_USERINFO, int: uid)
    }
    
}
extension SocketServer: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            print("inputStream has something to pass")
            let s = self.readStringFrom(stream: aStream as! InputStream)
            print(s)
            self.closeNetworkConnection()
            if let s = s {
                self.delegate?.socketDataReceived(result: Data(s.utf8))
            }else {
                self.delegate?.receivedNil()
            }
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
    
    /**
     Gets an `UnsafeMutablePointer<UInt8>` buffer of the inputStream bytes of size.
     
     - Parameter stream: InputStream to read from.
     
     - Parameter size: The size of bytes to read.
     
     - Returns: `UnsafeMutablePointer<UInt8>` buffer of bytes.
     */
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
    
    /**
     Reads data from InputStream with size.
     Calls `getBufferFrom(stream,size)` and gets data from buffer.
     
     - Parameters:
        - stream: InputStream to read from.
        - size: The size of bytes to read.
     
     - Returns: `Data` of bytes from InputStream.
     */
    private func readDataFrom(stream: InputStream, size: Int) -> Data? {
        let buffer = getBufferFrom(stream: stream, size: size)
        
        return Data(bytes: buffer, count: size)
    }
    
    /**
     Reads `String` from InputStream by calling `readDataFrom(stream,size)`.
     
     - Parameters:
        - stream: InputStream to read from.
        - withSize: The size of bytes to read.
     
     - Returns: `String` of bytes from InputStream.
     */
    private func readStringFrom(stream: InputStream, withSize: Int) -> String? {
        print("size: \(withSize)")
        let d = readDataFrom(stream: stream, size: withSize)!
        print("data: \(d.count)")
        let s = String(data: d, encoding: .utf8)
//        let buffer = getBufferFrom(stream: stream, size: withSize)
//        let s = String(cString: buffer)
        return s
    }
    
    /**
     Reads `String` from InputStream by first reading the Int of length of the String sent by server, and then calling `readStringFrom(stream,withSize)`.
     
     - Parameter stream: InputStream to read from.
     
     - Returns: `String` of bytes from InputStream.
     */
    private func readStringFrom(stream: InputStream) -> String? {
        let len: Int = Int(Int32(readIntFrom(stream: inputStream)!))
        return readStringFrom(stream: stream, withSize: len)
    }
    
    /**
     Reads `UInt32` from InputStream by calling `getBufferFrom(stream,size=4)` and converting bytes to an Int.
     
     - Parameter stream: InputStream to read from.
     
     - Returns: `UInt32` a full int.
     */
    private func readIntFrom(stream: InputStream) -> UInt32? {
        let buffer = getBufferFrom(stream: stream, size: 4)
        var int: UInt32 = 0
        let data = NSData(bytes: buffer, length: 4)
        data.getBytes(&int, length: 4)
        int = UInt32(bigEndian: int)
        buffer.deallocate()
        return int
    }
    
    /**
     Reads `UInt8` from InputStream by calling `getBufferFrom(stream,size=1)` and converting byte to an Int.
     
     - Parameter stream: InputStream to read from.
     
     - Returns: `UInt8` int of one byte.
     */
    private func readUInt8From(stream: InputStream) -> UInt8? {
        let buffer = getBufferFrom(stream: stream, size: 1)
        buffer.deallocate()
        return buffer.pointee
    }
    
    /**
     Writes a `String` to OutputStream by sending it as bytes.
     
     - Parameter string: The `String` to write to OutputStream.
     */
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
    
    /**
     Writes an `Int` to OutputStream by sending it as bytes.
     
     - Parameter int: The `Int` to write to OutputStream.
     */
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


