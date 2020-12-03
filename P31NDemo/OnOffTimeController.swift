//
//  OnOffTimeController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class OnOffTimeController: UIViewController, ASRP31NSDKDelegate{
    private var onTime: UInt16!
    private var offTime: UInt16!
    @IBOutlet private weak var tfOnTime: UITextField!
    @IBOutlet private weak var tfOffTime: UITextField!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ASRP31NSDK.sharedInstance().delegate = self
        perform(#selector(onTickGetOnOffTime), with: nil, afterDelay: 0.2)
        Utils.showLoadingView("Check Settings", timeOut: Int32(dfTIMEOUTDEFAULT))
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ASRP31NSDK.sharedInstance().delegate = nil
    }
    // MARK: - IBAction
    @IBAction func btnSetOnOffTime(_ sender: Any) {
        let minStr: Int = Int(tfOffTime.text ?? "") ?? 0
        if minStr < 10 {
            tfOffTime.text = "10"
        }
        let maxStr: Int = Int(tfOffTime.text ?? "" ) ?? 0
        if maxStr > 40000 {
            tfOffTime.text = "40000"
        }
        let onTime = __uint16_t(tfOnTime.text ?? "")
        let offTime = __uint16_t(tfOffTime.text ?? "")
        let error = ASRP31NSDK.sharedInstance()?.setFHLBTParamRFLevel(-740, readTime: onTime ?? 0, idleTime: offTime ?? 0, carrierSenseTime: 50, frequencyHopping: 1, listenBeforeTalk: 2, continuousWave: 0)
        guard let err: NSError = error as NSError? else {
            return
        }
        let string = err.userInfo
        let aaa: Int = string.count
        if aaa != 0 {
            print("\(#function)\n code = \(err.code)\n\(err.userInfo)")
        }
    }
    // MARK: - Private Method
    @objc func onTickGetOnOffTime() {
        let error = ASRP31NSDK.sharedInstance().getFHLBTParam()
        guard let err: Error = error as Error? else {
            return
        }
        let string = err._userInfo
        let aaa: Int = string?.count ?? 0
        if aaa != 0 {
            print("\(#function)\n code = \(err._code)\n\(String(describing: err._userInfo))")
        }
    }
    // MARK: - ASRP31NSDKDelegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedFHLBT fhlb: Data!) {
        Utils.hiddenLoadingView()
        var bytes = [UInt8](fhlb)
        let b: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(&bytes)
        let readTime: Int = Int((b[0] << 8) | b[1])
        let idleTime: Int = Int((b[2] << 8) | b[3])
        DispatchQueue.main.async {
            self.tfOnTime.text  = "\(readTime)"
            self.tfOffTime.text = "\(idleTime)"
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedDidSetFHLBT statusCode: ASRP31NSDKCommonStatus) {
        switch statusCode {
        case .success:
            Utils.showAlert("Success", message: "On/Off time changed", view: self)
        case .failure:
            Utils.showAlert("Fail", message: "On/Off time changed", view: self)
        default:
            break
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
