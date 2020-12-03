//
//  OutputPowerController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit
let DFREADTIMEMIN = 10
let DFREADTIMEMAX = 2550

class OutputPowerController: UITableViewController, ASRP31NSDKDelegate {
    private var maxPowerValue: Int!
    private var minPowerValue: Int!
    private var powerAnt1: __uint16_t!
    private var powerAnt2: __uint16_t!
    private var powerAnt3: __uint16_t!
    private var powerAnt4: __uint16_t!
    private var powerAnt5: __uint16_t!
    private var powerAnt6: __uint16_t!
    private var powerAnt7: __uint16_t!
    private var powerAnt8: __uint16_t!
    private var readTimeAnt1: __uint16_t!
    private var readTimeAnt2: __uint16_t!
    private var readTimeAnt3: __uint16_t!
    private var readTimeAnt4: __uint16_t!
    private var readTimeAnt5: __uint16_t!
    private var readTimeAnt6: __uint16_t!
    private var readTimeAnt7: __uint16_t!
    private var readTimeAnt8: __uint16_t!
    private var arrPowerRange: NSMutableArray = NSMutableArray()
    @IBOutlet private var txtFieldReadTimeAnt1: UITextField!
    @IBOutlet private var txtFieldReadTimeAnt2: UITextField!
    @IBOutlet private var txtFieldReadTimeAnt3: UITextField!
    @IBOutlet private var txtFieldReadTimeAnt4: UITextField!
    @IBOutlet private var txtFieldReadTimeAnt5: UITextField!
    @IBOutlet private var txtFieldReadTimeAnt6: UITextField!
    @IBOutlet private var txtFieldReadTimeAnt7: UITextField!
    @IBOutlet private var txtFieldReadTimeAnt8: UITextField!
    @IBOutlet private var txtFieldOutPwrAnt1: UITextField!
    @IBOutlet private var txtFieldOutPwrAnt2: UITextField!
    @IBOutlet private var txtFieldOutPwrAnt3: UITextField!
    @IBOutlet private var txtFieldOutPwrAnt4: UITextField!
    @IBOutlet private var txtFieldOutPwrAnt5: UITextField!
    @IBOutlet private var txtFieldOutPwrAnt6: UITextField!
    @IBOutlet private var txtFieldOutPwrAnt7: UITextField!
    @IBOutlet private var txtFieldOutPwrAnt8: UITextField!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrPowerRange.removeAllObjects()
        ASRP31NSDK.sharedInstance().delegate = self
        perform(#selector(onTickGetOuputPower), with: nil, afterDelay: 2)
        perform(#selector(onTickGetReadTime), with: nil, afterDelay: 4)
        Utils.showLoadingView("Check Settings", timeOut: Int32(dfTIMEOUTDEFAULT))
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ASRP31NSDK.sharedInstance().delegate = nil
    }
    // MARK: - IBAction
    @IBAction func setOutputPowerButtonAction(_ sender: Any) {
        updateTxValue()
        if checkInputValue() {
            Utils.showLoadingView("Change OutputPower", timeOut: Int32(dfTIMEOUTDEFAULT))
            let error =  ASRP31NSDK.sharedInstance()?.setOutputPowerLevelAntenna1(powerAnt1, antenna2: powerAnt2, antenna3: powerAnt3, antenna4: powerAnt4, antenna5: powerAnt5, antenna6: powerAnt6, antenna7: powerAnt8, antenna8: powerAnt8)
            guard let err: NSError = error as NSError? else {
                return
            }
            let string = err.userInfo
            let aaa: Int = string.count
            if aaa != 0 {
                print("\(#function)\n code = \(err.code)\n\(err.userInfo)")
            }
        }
    }
    // MARK: - PrivateMethod
    @objc func onTickGetOuputPower() {
        let error = ASRP31NSDK.sharedInstance().getOutputPowerLevelForMultiAntenna()
        guard let err: Error = error as Error? else {
            return
        }
        let string = err._userInfo
        let aaa: Int = string?.count ?? 0
        if aaa != 0 {
            print("\(#function)\n code = \(err._code)\n\(String(describing: err._userInfo))")
        }
    }
    @objc func onTickGetReadTime() {
        let error = ASRP31NSDK.sharedInstance().getReadTimeForMultiAntenna()
        guard let err: Error = error as Error? else {
            return
        }
        let string = err._userInfo
        let aaa: Int = string?.count ?? 0
        if aaa != 0 {
            print("\(#function)\n code = \(err._code)\n\(String(describing: err._userInfo))")
        }
    }
    func checkInputValue() -> Bool {
        let errPowerMessage = " Min \(Float(minPowerValue / 10)) MAX \(Float(maxPowerValue / 10))"
        let errReadTimeMessage = " Min \(DFREADTIMEMIN) MAX \(DFREADTIMEMAX)"
        var isErrorPower = false
        if (powerAnt1 < minPowerValue) || (powerAnt1 > maxPowerValue) {
            isErrorPower = true
        }
        if (powerAnt2 < minPowerValue) || (powerAnt2 > maxPowerValue) {
            isErrorPower = true
        }
        if (powerAnt3 < minPowerValue) || (powerAnt3 > maxPowerValue) {
            isErrorPower = true
        }
        if (powerAnt4 < minPowerValue) || (powerAnt4 > maxPowerValue) {
            isErrorPower = true
        }
        if (powerAnt5 < minPowerValue) || (powerAnt5 > maxPowerValue) {
            isErrorPower = true
        }
        if (powerAnt6 < minPowerValue) || (powerAnt6 > maxPowerValue) {
            isErrorPower = true
        }
        if (powerAnt7 < minPowerValue) || (powerAnt7 > maxPowerValue) {
            isErrorPower = true
        }
        if (powerAnt8 < minPowerValue) || (powerAnt8 > maxPowerValue) {
            isErrorPower = true
        }
        var isErrorReadtime = false
        if (readTimeAnt1 < DFREADTIMEMIN) || (readTimeAnt1 > DFREADTIMEMAX) {
            isErrorReadtime = true
        }
        if (readTimeAnt2 < DFREADTIMEMIN) || (readTimeAnt2 > DFREADTIMEMAX) {
            isErrorReadtime = true
        }
        if (readTimeAnt3 < DFREADTIMEMIN) || (readTimeAnt3 > DFREADTIMEMAX) {
            isErrorReadtime = true
        }
        if (readTimeAnt4 < DFREADTIMEMIN) || (readTimeAnt4 > DFREADTIMEMAX) {
            isErrorReadtime = true
        }
        if (readTimeAnt5 < DFREADTIMEMIN) || (readTimeAnt5 > DFREADTIMEMAX) {
            isErrorReadtime = true
        }
        if (readTimeAnt6 < DFREADTIMEMIN) || (readTimeAnt6 > DFREADTIMEMAX) {
            isErrorReadtime = true
        }
        if (readTimeAnt7 < DFREADTIMEMIN) || (readTimeAnt7 > DFREADTIMEMAX) {
            isErrorReadtime = true
        }
        if (readTimeAnt8 < DFREADTIMEMIN) || (readTimeAnt8 > DFREADTIMEMAX) {
            isErrorReadtime = true
        }
        if isErrorPower {
            Utils.showAlert("Power Range value error", message: errPowerMessage, view: self)
        }
        if isErrorReadtime {
            Utils.showAlert("Read Time Range value error", message: errReadTimeMessage, view: self)
        }
        if !isErrorPower && !isErrorReadtime {
            return true
        } else {
            return false
        }
    }
    func updateTxValue() {
        let antFloat1 = txtFieldOutPwrAnt1.text ?? ""
        let antInt1: Float = Float(antFloat1) ?? 0
        powerAnt1 = __uint16_t(antInt1 * 10)
        
        let antFloat2 = txtFieldOutPwrAnt2.text ?? ""
        let antInt2: Float = Float(antFloat2) ?? 0
        powerAnt2 = __uint16_t(antInt2 * 10)
        
        let antFloat3 = txtFieldOutPwrAnt3.text ?? ""
        let antInt3: Float = Float(antFloat3) ?? 0
        powerAnt3 = __uint16_t(antInt3 * 10)
        
        let antFloat4 = txtFieldOutPwrAnt4.text ?? ""
        let antInt4: Float = Float(antFloat4) ?? 0
        powerAnt4 = __uint16_t(antInt4 * 10)
        
        let antFloat5 = txtFieldOutPwrAnt5.text ?? ""
        let antInt5: Float = Float(antFloat5) ?? 0
        powerAnt5 = __uint16_t(antInt5 * 10)
        
        let antFloat6 = txtFieldOutPwrAnt6.text ?? ""
        let antInt6: Float = Float(antFloat6) ?? 0
        powerAnt6 = __uint16_t(antInt6 * 10)
        
        let antFloat7 = txtFieldOutPwrAnt7.text ?? ""
        let antInt7: Float = Float(antFloat7) ?? 0
        powerAnt7 = __uint16_t(antInt7 * 10)
        
        let antFloat8 = txtFieldOutPwrAnt8.text ?? ""
        let antInt8: Float = Float(antFloat8) ?? 0
        powerAnt8 = __uint16_t(antInt8 * 10)
        
        readTimeAnt1 = __uint16_t(txtFieldReadTimeAnt1.text ?? "")
        readTimeAnt2 = __uint16_t(txtFieldReadTimeAnt2.text ?? "")
        readTimeAnt3 = __uint16_t(txtFieldReadTimeAnt3.text ?? "")
        readTimeAnt4 = __uint16_t(txtFieldReadTimeAnt4.text ?? "")
        readTimeAnt5 = __uint16_t(txtFieldReadTimeAnt5.text ?? "")
        readTimeAnt6 = __uint16_t(txtFieldReadTimeAnt6.text ?? "")
        readTimeAnt7 = __uint16_t(txtFieldReadTimeAnt7.text ?? "")
        readTimeAnt8 = __uint16_t(txtFieldReadTimeAnt8.text ?? "")
    }
    func updateValue() {
        txtFieldOutPwrAnt1.text = String(format: "%.1f", Float(powerAnt1 ?? 0) / 10.0)
        txtFieldOutPwrAnt2.text = String(format: "%.1f", Float(powerAnt2 ?? 0) / 10.0)
        txtFieldOutPwrAnt3.text = String(format: "%.1f", Float(powerAnt3 ?? 0) / 10.0)
        txtFieldOutPwrAnt4.text = String(format: "%.1f", Float(powerAnt4 ?? 0) / 10.0)
        txtFieldOutPwrAnt5.text = String(format: "%.1f", Float(powerAnt5 ?? 0) / 10.0)
        txtFieldOutPwrAnt6.text = String(format: "%.1f", Float(powerAnt6 ?? 0) / 10.0)
        txtFieldOutPwrAnt7.text = String(format: "%.1f", Float(powerAnt7 ?? 0) / 10.0)
        txtFieldOutPwrAnt8.text = String(format: "%.1f", Float(powerAnt8 ?? 0) / 10.0)
        txtFieldReadTimeAnt1.text = "\(readTimeAnt1 ?? 0)"
        txtFieldReadTimeAnt2.text = "\(readTimeAnt2 ?? 0)"
        txtFieldReadTimeAnt3.text = "\(readTimeAnt3 ?? 0)"
        txtFieldReadTimeAnt4.text = "\(readTimeAnt4 ?? 0)"
        txtFieldReadTimeAnt5.text = "\(readTimeAnt5 ?? 0)"
        txtFieldReadTimeAnt6.text = "\(readTimeAnt6 ?? 0)"
        txtFieldReadTimeAnt7.text = "\(readTimeAnt7 ?? 0)"
        txtFieldReadTimeAnt8.text = "\(readTimeAnt8 ?? 0)"
    }
    // MARK: - ASRP31NSDK Delegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedReadTimeAntenna1 antenna1: UInt16, antenna2: UInt16, antenna3: UInt16, antenna4: UInt16, antenna5: UInt16, antenna6: UInt16, antenna7: UInt16, antenna8: UInt16) {
        Utils.hiddenLoadingView()
        readTimeAnt1 = antenna1
        readTimeAnt2 = antenna2
        readTimeAnt3 = antenna3
        readTimeAnt4 = antenna4
        readTimeAnt5 = antenna5
        readTimeAnt6 = antenna6
        readTimeAnt7 = antenna7
        readTimeAnt8 = antenna8
        DispatchQueue.main.async {
            self.updateValue()
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedOuputPowerAntenna1 antenna1: UInt16, antenna2: UInt16, antenna3: UInt16, antenna4: UInt16, antenna5: UInt16, antenna6: UInt16, antenna7: UInt16, antenna8: UInt16, min: UInt16, max: UInt16) {
        powerAnt1 = antenna1
        powerAnt2 = antenna2
        powerAnt3 = antenna3
        powerAnt4 = antenna4
        powerAnt5 = antenna5
        powerAnt6 = antenna6
        powerAnt7 = antenna7
        powerAnt8 = antenna8
        maxPowerValue = Int(max)
        minPowerValue = Int(min)
        DispatchQueue.main.async {
            self.updateValue()
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, didSetOutputPowerForMultiAntenna statusCode: ASRP31NSDKCommonStatus) {
        Utils.hiddenLoadingView()
        switch statusCode {
        case .success:
            Utils.showLoadingView("Change ReadTime", timeOut: Int32(dfTIMEOUTDEFAULT))
            let error = ASRP31N.setReadTimeForMultiAntenna1(readTimeAnt1, antenna2: readTimeAnt2, antenna3: readTimeAnt3, antenna4: readTimeAnt4, antenna5: readTimeAnt5, antenna6: readTimeAnt6, antenna7: readTimeAnt7, antenna8: readTimeAnt8)
            guard let err: NSError = error as NSError? else {
                return
            }
            let string = err.userInfo
            let aaa: Int = string.count
            if aaa != 0 {
                print("\(#function)\n code = \(err.code)\n\(err.userInfo)")
            }
        case .failure:
            Utils.showAlert("Fail", message: "OutPut Power  changed", view: self)
        default:
            break
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, didSetReadTimeForMultiAntenna statusCode: ASRP31NSDKCommonStatus) {
        Utils.hiddenLoadingView()
        switch statusCode {
        case .success:
            Utils.showAlert("Success", message: "Read Time changed", view: self)
        case .failure:
            Utils.showAlert("Fail", message: "Read Time changed", view: self)
        default:
            break
        }
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
