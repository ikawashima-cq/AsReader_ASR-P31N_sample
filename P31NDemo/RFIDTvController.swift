//
//  RFIDTvController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class RFIDTvController: UITableViewController, ASRP31NSDKDelegate {
    @IBOutlet private weak var labelSession: UILabel!
    @IBOutlet private weak var labelChannel: UILabel!
    @IBOutlet private weak var swRSSI: UISwitch!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ASRP31NSDK.sharedInstance().delegate = self
        Utils.showLoadingView("Check Settings", timeOut: Int32(dfTIMEOUTDEFAULT))
        let isRSSIOn = Bool(UserDefaults.standard.bool(forKey: "RSSI"))
        self.swRSSI.isOn = isRSSIOn
        perform(#selector(onTickGetSession), with: nil, afterDelay: 0.2)
        perform(#selector(onTickGetChannel), with: nil, afterDelay: 0.4)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ASRP31NSDK.sharedInstance().delegate = nil
    }
    // MARK: - PrivateMethod
    @objc func onTickGetSession() {
        let error = ASRP31NSDK.sharedInstance()?.getSession()
        guard let err: Error = error as Error? else {
            return
        }
        let string = err._userInfo
        let aaa: Int = string?.count ?? 0
        if aaa != 0 {
            print("\(#function)\n code = \(err._code)\n\(String(describing: err._userInfo))")
        }
    }
    @objc func onTickGetChannel() {
        Utils.hiddenLoadingView()
        let error = ASRP31NSDK.sharedInstance()?.getChannel()
        guard let err: Error = error as Error? else {
            return
        }
        let string = err._userInfo
        let aaa: Int = string?.count ?? 0
        if aaa != 0 {
            print("\(#function)\n code = \(err._code)\n\(String(describing: err._userInfo))")
        }
    }
    // MARK: - IBAction
    @IBAction func btnUpdate(_ sender: Any) {
        let error = ASRP31NSDK.sharedInstance()?.updateRegistry()
        guard let err: Error = error as Error? else {
            return
        }
        let string = err._userInfo
        let aaa: Int = string?.count ?? 0
        if aaa != 0 {
            print("\(#function)\n code = \(err._code)\n\(String(describing: err._userInfo))")
        }
    }
    @IBAction func btnRSSIOnOff(_ sender: Any) {
        UserDefaults.standard.set(swRSSI.isOn, forKey: "RSSI")
        Utils.showAlert("Confirm", message: "RSSI On/Off Changed", view: self)
    }
    // MARK: - ASRP31NSDKDelegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, updatedRegistryStatus statusCode: UInt8) {
        if statusCode == 0x00 {
            Utils.showAlert("Success", message: "Update registry", view: self)
        } else {
            Utils.showAlert("Fail", message: "Update registry", view: self)
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedSession session: UInt8) {
        DispatchQueue.main.async {
            self.labelSession.text = "\(session)"
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedChannel channel: UInt8, offset: UInt8) {
        DispatchQueue.main.async {
            self.labelChannel.text = "\(channel)"
        }
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
