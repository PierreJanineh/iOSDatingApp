//
//  Extensions.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 03/03/2021.
//

import Foundation
extension UInt8 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
    }
}

extension Data {
    init(from value: UnsafeMutablePointer<UInt8>) {
        self = Swift.withUnsafeBytes(of: value) {
            Data($0)
        }
    }
    
}
