//
//  TagData.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit
import Foundation

let dfCELLTAGINFO     =    "TAG_INFO"
let dfCELLTAGCOUNT    =    "COUNT"
let dfCELLTAGRAW      =    "RAW"
let dfCELLTAGANT      =    "ANT"
let dfCELLTAGRSSI     =    "RSSI"
class TagData: NSObject {
    public var arrTags: NSMutableArray

    static private var tagData: TagData?
    public final class func shared() -> TagData? {
        if tagData == nil {
            tagData = TagData()
        }
        return tagData
    }
    override init() {
//        super.init()
        self.arrTags  = NSMutableArray()
    }
}
