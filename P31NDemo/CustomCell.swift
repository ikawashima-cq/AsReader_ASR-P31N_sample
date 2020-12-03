//
//  CustomCell.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet private weak var imgType: UIImageView!
    @IBOutlet private weak var tagHex: UILabel!
    @IBOutlet private weak var tagAnt: UILabel!
    @IBOutlet private weak var tagCount: UILabel!
    @IBOutlet private weak var tagRSSI: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    public func setTagHex(_ tagHex: String) {
        self.tagHex.text = tagHex
    }
    public func setTagAnt(_ tagAnt: String) {
        self.tagAnt.text = tagAnt
    }
    public func setTagCount(_ tagCount: String) {
        self.tagCount.text = tagCount
    }
    public func setTagRSSI(_ tagRSSI: String) {
        self.tagRSSI.text = tagRSSI
        guard tagRSSI.isEmpty else {
            self.tagRSSI.isHidden = false
            return
        }
        self.tagRSSI.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
