//
//  StopConditionController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class StopConditionController: UIViewController {
    @IBOutlet private weak var olStopTagCount: UITextField!
    @IBOutlet private weak var olStopTime: UITextField!
    @IBOutlet private weak var olStopCycle: UITextField!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let nTagCount = Int32(UserDefaults.standard.integer(forKey: "RFIDScanTagCount"))
        let nScanTime = Int32(UserDefaults.standard.integer(forKey: "RFIDScanTagTime"))
        let nCycle = Int32(UserDefaults.standard.integer(forKey: "RFIDScanTagInventory"))
        self.olStopTagCount.text = "\(nTagCount)"
        self.olStopTime.text = "\(nScanTime)"
        self.olStopCycle.text = "\(nCycle)"
    }
    // MARK: - Action
    @IBAction func rightBarButtonItemClicked(_ sender: Any) {
        self.olStopTagCount.resignFirstResponder()
        self.olStopTime.resignFirstResponder()
        self.olStopCycle.resignFirstResponder()
        let aaa: String = self.olStopTagCount.text ?? ""
        let stopTagCount = Int32(aaa)
        let bbb: String = self.olStopTime.text ?? ""
        let stopTime = Int32(bbb)
        let ccc: String = self.olStopCycle.text ?? ""
        let stopCycle = Int32(ccc)
        UserDefaults.standard.set(stopTagCount, forKey: "RFIDScanTagCount")
        UserDefaults.standard.set(stopTime, forKey: "RFIDScanTagTime")
        UserDefaults.standard.set(stopCycle, forKey: "RFIDScanTagInventory")
        Utils.showAlert("Confirm", message: "Changed Stop condition", view: self)
    }
}
