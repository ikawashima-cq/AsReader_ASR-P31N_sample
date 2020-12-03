//
//  ChannelController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class ChannelController: UIViewController, ASRP31NSDKDelegate {    
    @IBOutlet private weak var olChannel: UITextField!
    @IBOutlet private weak var olChannelInfo: UILabel!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.olChannel.text = "--"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ASRP31NSDK.sharedInstance().delegate = self
        ASRP31NSDK.sharedInstance().getChannel()
    }
    // MARK: - IBAction
    @IBAction func rightBarButtonItemClicked(_ sender: Any) {
        self.olChannel.resignFirstResponder()
        let aaa = self.olChannel.text
        guard let bbb = __uint8_t(aaa ?? "") else {
            return
        }
        ASRP31NSDK.sharedInstance()?.setChannel(bbb)
    }
    // MARK: - ASRP31NSDKDelegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedChannel channel: UInt8, offset: UInt8) {
        DispatchQueue.main.async {
            self.olChannel.text = "\(channel)"
        }
        ASRP31NSDK.sharedInstance()?.getFreqHoppingTable()
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedDidSetChParam statusCode: UInt8) {
        switch statusCode {
        case UInt8(ASRP31NSDKCommonStatus.success.rawValue):
            Utils.showAlert("Success", message: "Changed Channel Data", view: self)
        case UInt8(ASRP31NSDKCommonStatus.failure.rawValue):
            Utils.showAlert("Fail", message: "Changed Channel Data", view: self)
        default:
            break
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedHoppingTable table: Data!) {
        let strChannel = NSMutableString()
        var bytes = [UInt8](table)
        let ptr: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(&bytes)
        let nLen: Int = Int(ptr[0])
        for iii in 1..<nLen+1 {
            strChannel.appendFormat("%d,", ptr[iii])
        }
        let strInfo = "Size : \(nLen) \n \(strChannel)"
        DispatchQueue.main.async {
            self.olChannelInfo.text = strInfo
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedErrDetail errCode: Data!) {
        let errMessage: String = "\(String(describing: errCode))"
        Utils.showAlert("Err code", message: errMessage, view: self)
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, change state: ASRP31NSDKNetworkState, error: Error!) {
        switch state {
        case .disconnected:
            Utils.showAlert("Fail", message: "The network connection is lost.", view: self)
        case .error:
            break
        default:
            break
        }
    }
}
