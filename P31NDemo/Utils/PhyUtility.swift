//
//  PhyUtility.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit
import Foundation

extension String {
    func hexStringToBytes() -> NSData {
        let data = NSMutableData()
        for i in stride(from: 0, through: self.count - 2, by: 2) {
            let startIndex = self.index(self.startIndex, offsetBy: i)
            let endIndex =  self.index(self.startIndex, offsetBy: i + 2)
            let hexStr = String(self[startIndex..<endIndex])
            var intValue: UInt64 = 0
            Scanner(string: hexStr).scanHexInt64(&intValue)
            data.append(&intValue, length: 1)
        }
        return data
    }
    func stringToHex() -> NSData {
        let data = NSMutableData()
        let msgtext: NSMutableString = NSMutableString(string: self)
        for i in 0..<self.count {
            let hexStr = msgtext.substring(with: NSRange(location: i, length: 2))
            var intValue: Int = 0
            Scanner(string: hexStr).scanInt(&intValue)
            data.append(&intValue, length: 1)
        }
        return data
    }
}
extension Data {
    var toBytes: [UInt8] {
        var aBuffer = [UInt8](repeating: 0, count: self.count)
        (self as NSData).getBytes(&aBuffer, length: self.count)
        return aBuffer
    }
    func hexadecimalString() -> String? {
        let buffer = (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count)
        var hexadecimalString: String = ""
        for i in 0..<self.count {
            hexadecimalString += String(format: "%02x", buffer.advanced(by: i).pointee)
        }
        return hexadecimalString
    }
    func epcString() -> String? {
        let buffer = (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count)
        var hexadecimalString: String = ""
        for i in 2..<self.count {
            hexadecimalString += String(format: "%02x", buffer.advanced(by: i).pointee)
        }
        return hexadecimalString
    }
}
