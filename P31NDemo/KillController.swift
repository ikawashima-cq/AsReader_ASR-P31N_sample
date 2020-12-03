//
//  KillController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class KillController: UIViewController, ASRP31NSDKDelegate {
    @IBOutlet private weak var olTargetEpc: UITextField!
    @IBOutlet private weak var olKillPassword: UITextField!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ASRP31NSDK.sharedInstance().delegate = self
        let selectTag = SelectedTagInfo.sharedDanli()
        self.olTargetEpc.text = selectTag.selectedTagEPC
    }
    // MARK: - IBAction
    @IBAction func rightBarButtonItemClicked(_ sender: Any) {
        self.olTargetEpc.resignFirstResponder()
        let hexaString = self.olKillPassword.text
        var killpassword: UInt32 = 0
        Scanner(string: hexaString ?? "").scanHexInt32(&killpassword)
        guard let epcs = self.olTargetEpc.text?.hexStringToBytes() else {
            return
        }
        ASRP31NSDK.sharedInstance().setKillTag(killpassword, epc: epcs as Data)
    }
    // MARK: - ASRP31NSDKDelegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedDidKilled statusCode: UInt8) {
        switch statusCode {
        case UInt8(ASRP31NSDKCommonStatus.success.rawValue):
            Utils.showAlert("Success", message: "Killed", view: self)
        case UInt8(ASRP31NSDKCommonStatus.failure.rawValue):
            Utils.showAlert("Fail", message: "Killed", view: self)
        default:
            break
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
        case .error: break
        default:
            break
        }
    }
}
