//
//  SelectedTagInfo.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit
import Foundation

class SelectedTagInfo: NSObject {
    var selectedTagEPC: String = ""
    
    static let instance: SelectedTagInfo = SelectedTagInfo()
    class func sharedDanli() -> SelectedTagInfo {
        return instance
    }
}
