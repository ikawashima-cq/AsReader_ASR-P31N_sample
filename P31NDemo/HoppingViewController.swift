//
//  HoppingViewController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class HoppingViewController: UIViewController, ASRP31NSDKDelegate {
    private var readTime: __uint16_t! = 0
    private var idleTime: __uint16_t! = 0
    private var cst: __uint16_t! = 0
    private var rfl: Int!
    private var fh: Int!
    private var lbt: Int!
    private var cw: Int!
    @IBOutlet private weak var labelInfo: UILabel?
    @IBOutlet private weak var swOnOff: UISwitch?
    @IBOutlet private weak var swMode: UISwitch?
    @IBOutlet private weak var btnStep2: UIButton?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hopping"
        getInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ASRP31NSDK.sharedInstance().delegate = self
        Utils.showLoadingView("Check Hopping", timeOut: Int32(dfTIMEOUTDEFAULT))
        perform(#selector(onTickGetFHInfo), with: nil, afterDelay: 0.2)
        perform(#selector(onTickSmartHoppingInfo), with: nil, afterDelay: 0.4)
        self.swMode?.isHidden = false
        self.btnStep2?.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ASRP31NSDK.sharedInstance().delegate = nil
    }
    // MARK: - PrivateMethod
    func getInfo() {
        let strInfo = NSMutableString()
        strInfo.append("\n \("On Time : "):\(readTime ?? 0)")
        strInfo.append("\n \("Off Time : "):\(idleTime ?? 0)")
        strInfo.append("\n \("CST : "):\(cst ?? 0)")
        strInfo.append("\n \("FH Val : "):\(fh ?? 0)")
        strInfo.append("\n \("LBT : "):\(lbt ?? 0)")
        strInfo.append("\n \("RFL : "):\(rfl ?? 0)")
        strInfo.append("\n \("CW  : "):\(cw ?? 0)")
        DispatchQueue.main.async {
            self.labelInfo?.text = strInfo as String
        }
        guard let fhInt = fh else {
            Utils.hiddenLoadingView()
            return
        }
        guard let lbtInt = lbt else {
            Utils.hiddenLoadingView()
            return
        }
        if fhInt > lbtInt {
            DispatchQueue.main.async {
                self.swOnOff?.isOn = true
            }
        } else {
            DispatchQueue.main.async {
                self.swOnOff?.isOn = false
            }
        }
        Utils.hiddenLoadingView()
    }
    @objc func onTickGetFHInfo() {
        ASRP31NSDK.sharedInstance().getFHLBTParam()
    }
    @objc func onTickSmartHoppingInfo() {
        ASRP31NSDK.sharedInstance().getSmartHoppingOnOff()
    }
    // MARK: - IBAction
    @IBAction func btnSelectHoppingmode(_ sender: Any) {
        let sw = (sender as? UISwitch)
        if sw?.isOn == true {
            Utils.showAlert("Confirm", message: "Selected Smart Mode   => push Step2", view: self)
        } else {
            Utils.showAlert("Confirm", message: "Selected Normal Mode  => push Step2", view: self)
        }
    }
    @IBAction func actionSwitchHoppingOnOff(_ sender: UISwitch) {
        let aaa = Int32(rfl ?? 0)
        if sender.isOn == true {
            ASRP31NSDK.sharedInstance().setFHLBTParamRFLevel(aaa, readTime: readTime, idleTime: idleTime, carrierSenseTime: cst, frequencyHopping: 1, listenBeforeTalk: 0, continuousWave: 0)
        } else {
            ASRP31NSDK.sharedInstance().setFHLBTParamRFLevel(aaa, readTime: readTime, idleTime: idleTime, carrierSenseTime: cst, frequencyHopping: 0, listenBeforeTalk: 1, continuousWave: 0)
        }
    }
    @IBAction func btnRefleshInfo(_ sender: Any) {
        ASRP31NSDK.sharedInstance().getFHLBTParam()
    }
    @IBAction func btnStep1(_ sender: Any) {
        ASRP31NSDK.sharedInstance().setOptimumFrequencyHoppingTable()
    }
    @IBAction func btnStep2(_ sender: Any) {
        let bol: Bool = self.swMode?.isOn ?? false
        ASRP31NSDK.sharedInstance()?.setSmartHoppingOnOff(bol)
    }
    // MARK: - ASRP31NSDKDelegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedFHLBT fhlb: Data!) {
        var bytes = [UInt8](fhlb)
        let bbb: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(&bytes)
        if !(fhlb.count < 11) {
            readTime = __uint16_t((bbb[0] << 8) | bbb[1])
            idleTime = __uint16_t((bbb[2] << 8) | bbb[3])
            cst = __uint16_t((bbb[4] << 8) | bbb[5])
            rfl = Int((bbb[6] << 8) | bbb[7])
            fh  = Int(bbb[8])
            lbt = Int(bbb[9])
            cw = Int(bbb[10])
        }
        getInfo()
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedDidSetFHLBT statusCode: ASRP31NSDKCommonStatus) {
        Utils.showAlert("Confirm", message: "Set FH/LBT Param", view: self)
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedDidSetOptiFreqHPTable statusCode: UInt8) {
        if statusCode == 0x00 {
            Utils.showLoadingView("Wait!! Start OptiMum Freq Start", timeOut: Int32(dfTIMEOUTDEFAULT))
        } else if statusCode == 0x01 {
            Utils.hiddenLoadingView()
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedDidSetSmartHopping statusCode: UInt8) {
        switch statusCode {
        case UInt8(ASRP31NSDKCommonStatus.success.rawValue):
            Utils.showAlert("Success", message: "Changed Smart Hopping Mode", view: self)
        case UInt8(ASRP31NSDKCommonStatus.failure.rawValue):
            Utils.showAlert("Fail", message: "Changed Smart Hopping Mode", view: self)
        default:
            break
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedSmartHopping isON: Bool) {
        DispatchQueue.main.async {
            self.swMode?.setOn(isON, animated: true)
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedErrDetail errCode: Data!) {
        var bytes = [UInt8](errCode)
        let ptr: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(&bytes)
        Utils.hiddenLoadingView()
        DispatchQueue.main.async {
            switch ptr [1] {
            case 0xE4:
                print("0xE4  \(ptr[1])")
            case 0xE6:
                print("0xE6  \(ptr[1])")
            case 0xD2:
                Utils.showAlert("Error", message: "The retrun loss of antenna is too large to optimize channel.", view: self)
            default:
                break
            }
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
