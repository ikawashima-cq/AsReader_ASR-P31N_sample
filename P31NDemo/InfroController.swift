//
//  InfroController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class InfroController: UITableViewController, ASRP31NSDKDelegate {
    @IBOutlet private weak var olRegion: UILabel!
    @IBOutlet private weak var olRFODModule: UILabel!
    @IBOutlet private weak var olSDKVersion: UILabel!
    @IBOutlet private weak var olAppVersion: UILabel!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ASRP31NSDK.sharedInstance().delegate = self
        self.olAppVersion.text = self.getAppVersion()
        self.olSDKVersion.text = ASRP31NSDK.sharedInstance().getVersion()
        Utils.showLoadingView("Check Reader Info", timeOut: Int32(dfTIMEOUTDEFAULT))
        perform(#selector(onTickGetRegion), with: nil, afterDelay: 0.5)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        ASRP31NSDK.sharedInstance().delegate = nil
    }
    // MARK: - PrivateMethod
    @objc func onTickGetRegion() {
        ASRP31NSDK.sharedInstance().getRegion()
    }
    func onTickGetRFIDModuleVersion() {
        ASRP31NSDK.sharedInstance().getRFIDMoudleVersion()
    }
    func getAppVersion() -> String {
        let dictionary = Bundle.main.infoDictionary
        guard let dic = dictionary as NSDictionary? else {
            return ""
        }
        guard let majorVersion = dic.value(forKey: "CFBundleShortVersionString") else {
            return ""
        }
        guard let minorVersion = dic.value(forKey: "CFBundleVersion") else {
            return ""
        }
        return "major :\(String(describing: majorVersion)) (\(String(describing: minorVersion)))"
    }
    // MARK: - ASRP31NSDKDelegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedRegion region: UInt8) {
        var sRegion: String = "--"
        switch region {
        case 0x11:
            sRegion = "Korea"
        case 0x21:
            sRegion = "US Wide"
        case 0x22:
            sRegion = "US Narrow"
        case 0x31:
            sRegion = "Europe"
        case 0x41:
            sRegion = "Japan"
        case 0x52:
            sRegion = "China"
        case 0x61:
            sRegion = "Brazil"
        default:
            sRegion = "Unknown"
        }
        DispatchQueue.main.async {
            self.olRegion.text = sRegion
        }
        onTickGetRFIDModuleVersion()
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedRfidModuleVersion version: String!) {
        DispatchQueue.main.async {
            self.olRFODModule.text = version
            Utils.hiddenLoadingView()
        }
    }
}
