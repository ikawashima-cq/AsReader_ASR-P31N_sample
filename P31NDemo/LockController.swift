//
//  LockController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class LockController: UIViewController, ASRP31NSDKDelegate {
    @IBOutlet private weak var olTargetEpc: UITextField!
    @IBOutlet private weak var olAccessPassword: UITextField!
    @IBOutlet private weak var olTargetMemory: UISegmentedControl!
    @IBOutlet private weak var olAction: UISegmentedControl!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let selectTag = SelectedTagInfo.sharedDanli()
        self.olTargetEpc.text = selectTag.selectedTagEPC
        ASRP31NSDK.sharedInstance().delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ASRP31NSDK.sharedInstance().delegate = nil
    }
    // MARK: - IBAction
    @IBAction func rightBarButtonItemClicked(_ sender: Any) {
        self.olTargetEpc.resignFirstResponder()
        let hexaString = self.olAccessPassword.text
        var accesspassword: UInt32 = 0
        Scanner(string: hexaString ?? "").scanHexInt32(&accesspassword)
        var lock: Int = 0
        let seed: Int = self.olAction.selectedSegmentIndex 
        switch self.olTargetMemory.selectedSegmentIndex {
        case 0:
            // Kill
            lock = (seed << 8) | (3 << 18)
        case 1:
            // Access
            lock = (seed << 6) | (3 << 16)
        case 2:
            // EPC
            lock = (seed << 4) | (3 << 14)
        case 3:
            // TID
            lock = (seed << 2) | (3 << 12)
        case 4:
            // USER
            lock = (seed << 0) | (3 << 10)
        default:
            break
        }
        guard let epcs = self.olTargetEpc.text?.hexStringToBytes() else {
             return
        }
        ASRP31NSDK.sharedInstance()?.setLockTagMemory(__uint32_t(accesspassword), epc: epcs as Data, lockData: __uint32_t(lock))
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedDidLocked statusCode: UInt8) {
        if statusCode == UInt8(ASRP31NSDKCommonStatus.success.rawValue) {
            Utils.showAlert("Confirm", message: "Lock Tag", view: self)
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedErrDetail errCode: Data!) {
        guard let tag = errCode.hexadecimalString() else {
            return
        }
        let errMessage: String = "\(tag)"
        Utils.showAlert("Err", message: errMessage, view: self)
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
