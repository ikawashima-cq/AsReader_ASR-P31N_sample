//
//  ViewController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController, ASRP31NSDKDelegate {
    @IBOutlet private var btnMore: UIBarButtonItem!
    @IBOutlet private var btnRead: UIButton!
    @IBOutlet private var labelIP: UILabel!
    @IBOutlet private var labelTags: UILabel!
    @IBOutlet private var viewBottom: UIView!
    @IBOutlet private var btnCheckAnt1: UIButton!
    @IBOutlet private var btnCheckAnt2: UIButton!
    @IBOutlet private var btnCheckAnt3: UIButton!
    @IBOutlet private var btnCheckAnt4: UIButton!
    @IBOutlet private var btnCheckAnt5: UIButton!
    @IBOutlet private var btnCheckAnt6: UIButton!
    @IBOutlet private var btnCheckAnt7: UIButton!
    @IBOutlet private var btnCheckAnt8: UIButton!
    private var arrIPs: NSMutableArray = NSMutableArray()
    private var selectIP: String = ""
    private var soundId: SystemSoundID = 0
    private var tagData = TagData.shared()
    private var tagViewController: TagViewController!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnMore.isEnabled = false
        setUpSound()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ASRP31NSDK.sharedInstance()?.delegate = self
        if (ASRP31NSDK.sharedInstance()?.getConnectionStatus()) == false {
            enableUis(isEnable: false)
        }
        
        let dictionary = Bundle.main.infoDictionary
        guard let dic = dictionary as NSDictionary? else {
            return
        }
        guard let version = dic.value(forKey: "CFBundleShortVersionString") else {
            return
        }
        guard let sdkVersion = ASRP31NSDK.sharedInstance()?.getVersion() else {
            return
        }
        self.navigationItem.title = "AsReader(A:\(String(describing: version))/S:\(String(describing: sdkVersion)))"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ASRP31NSDK.sharedInstance()?.delegate = nil
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopButtonAction(AnyClass.self)
    }
    // MARK: - Action
    @IBAction func searchDeviceButtonAction(_ sender: Any) {
        Utils.showLoadingView("Searching", timeOut: Int32(dfTIMEOUTDEFAULT + 2))
        arrIPs.removeAllObjects()
        ASRP31NSDK.sharedInstance()?.startSearchDevice()
    }
    @IBAction func checkButtonAction(_ sender: Any) {
        let btn = (sender as? UIButton)
        if btn?.tag == 0 {
            btn?.tag = 1
            btn?.setImage(UIImage(named: "checked.png"), for: UIControl.State.normal)
        } else {
            btn?.tag = 0
            btn?.setImage(UIImage(named: "uncheck.png"), for: UIControl.State.normal)
        }
    }
    @IBAction func readButtonAction(_ sender: Any) {
        let nTagCount = Int32(UserDefaults.standard.integer(forKey: "RFIDScanTagCount"))
        let nScanTime = Int32(UserDefaults.standard.integer(forKey: "RFIDScanTagTime"))
        let nCycle = Int32(UserDefaults.standard.integer(forKey: "RFIDScanTagInventory"))
        let isRSSIOn = Bool(UserDefaults.standard.bool(forKey: "RSSI"))
        let btn1 = btnCheckAnt1.tag
        let btn2 = btnCheckAnt2.tag
        let btn3 = btnCheckAnt3.tag
        let btn4 = btnCheckAnt4.tag
        let btn5 = btnCheckAnt5.tag
        let btn6 = btnCheckAnt6.tag
        let btn7 = btnCheckAnt7.tag
        let btn8 = btnCheckAnt8.tag
        var button1 = false
        if btn1 == 1 {
            button1 = true
        }
        var button2 = false
        if btn2 == 1 {
            button2 = true
        }
        var button3 = false
        if btn3 == 1 {
            button3 = true
        }
        var button4 = false
        if btn4 == 1 {
            button4 = true
        }
        var button5 = false
        if btn5 == 1 {
            button5 = true
        }
        var button6 = false
        if btn6 == 1 {
            button6 = true
        }
        var button7 = false
        if btn7 == 1 {
            button7 = true
        }
        var button8 = false
        if btn8 == 1 {
            button8 = true
        }
        if btn1 == 1 || btn2 == 1 || btn3 == 1 || btn4 == 1 || btn5 == 1 || btn6 == 1 || btn7 == 1 || btn8 == 1 {
            ASRP31NSDK.sharedInstance()?.startMultiReadTags(UInt8(nTagCount), mtime: UInt8(nScanTime), repeatCycle: UInt16(nCycle), antenna1Enable: button1, antenna2Enable: button2, antenna3Enable: button3, antenna4Enable: button4, antenna5Enable: button5, antenna6Enable: button6, antenna7Enable: button7, antenna8Enable: button8, rssiEnable: isRSSIOn)
        } else {
            Utils.showAlert("Confirm", message: "Please select Antenna", view: self)
            return
        }
        btnRead.isEnabled = false
        btnCheckAnt1.isEnabled = false
        btnCheckAnt2.isEnabled = false
        btnCheckAnt3.isEnabled = false
        btnCheckAnt4.isEnabled = false
        btnCheckAnt5.isEnabled = false
        btnCheckAnt6.isEnabled = false
        btnCheckAnt7.isEnabled = false
        btnCheckAnt8.isEnabled = false
    }
    @IBAction func stopButtonAction(_ sender: Any) {
        btnRead.isEnabled = true
        btnCheckAnt1.isEnabled = true
        btnCheckAnt2.isEnabled = true
        btnCheckAnt3.isEnabled = true
        btnCheckAnt4.isEnabled = true
        btnCheckAnt5.isEnabled = true
        btnCheckAnt6.isEnabled = true
        btnCheckAnt7.isEnabled = true
        btnCheckAnt8.isEnabled = true
        ASRP31NSDK.sharedInstance()?.stopReadTags()
    }
    @IBAction func clearButtonAction(_ sender: Any) {
        objc_sync_enter(self)
        tagData?.arrTags.removeAllObjects()
        let array: Int = tagData?.arrTags.count ?? 0
        labelTags?.text = "\(Int32(array)) Tags"
        tagViewController.updateData()
        objc_sync_exit(self)
    }
    // MARK: - Private Method
    func showAlertViewIPs() {
        let alert = UIAlertController(title: " * Found Device *", message: "Please select device IP", preferredStyle: .actionSheet)
        for value in arrIPs {
            let ipString = UIAlertAction(title: value as? String, style: .default, handler: { (_) in
                self.selectIP = value as? String ?? ""
                ASRP31NSDK.sharedInstance().connectServer(self.selectIP, port: 5000)})
            alert.addAction(ipString)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    func enableUis(isEnable: Bool) {
        DispatchQueue.main.async {
            if isEnable {
                self.labelIP.text = "Connected"
                self.labelIP.text = NSString (format: "%@", self.selectIP) as String
                self.viewBottom.isHidden = false
                self.btnMore.isEnabled = true
            } else {
                self.labelIP.text = "Disconnected"
                self.viewBottom.isHidden = true
                self.btnMore.isEnabled = false
            }
        }
    }
    func addScanDataFiltering(_ pcEpc: String, rawData dataRaw: NSData, selectAnt ant: Int32, RSSI nRSSI: Int32) {
        objc_sync_enter(self)
        var isNew = true
        let sAnt = "\(ant)"
        var rssiValue = ""
        if nRSSI != 0 {
            rssiValue = "\(nRSSI)"
        } else {
            rssiValue = ""
        }
        var index = 0
        guard let array = tagData?.arrTags as NSMutableArray? else {
            return
        }
        for dict in array {
            let epcDic = dict as? NSDictionary
            guard let oldPcEpc = epcDic?.value(forKey: dfCELLTAGINFO) else {
                break
            }
            let strOld = oldPcEpc as? String
            if strOld == pcEpc {
                guard let str = epcDic?.value(forKey: dfCELLTAGCOUNT) else {
                    break
                }
                let valueStr: String = str as? String ?? ""
                let number = Int(valueStr) ?? 0
                let count = number + 1
                let strCount = "\(count)"
                let inserDic: Dictionary = [dfCELLTAGINFO: pcEpc, dfCELLTAGCOUNT: strCount, dfCELLTAGANT: sAnt, dfCELLTAGRAW: dataRaw, dfCELLTAGRSSI: rssiValue] as [String: Any]
                tagData?.arrTags.replaceObject(at: index, with: inserDic)
                isNew = false
                break
            }
            index += 1
        }
        if isNew == true {
            let strCount = "1"
            let inserDic: Dictionary = [dfCELLTAGINFO: pcEpc, dfCELLTAGCOUNT: strCount, dfCELLTAGANT: sAnt, dfCELLTAGRAW: dataRaw, dfCELLTAGRSSI: rssiValue] as [String: Any]
            tagData?.arrTags.add(inserDic)
            playBeepSound()
        }
        DispatchQueue.main.async {
            self.tagViewController.updateData()
            let array: Int = self.tagData?.arrTags.count ?? 0
            self.labelTags.text = "\(Int32(array)) Tags"
        }
        objc_sync_exit(self)
    }
    func setUpSound() {
        let path = Bundle.main.url(forResource: "read", withExtension: "caf")
        guard let url = path as URL? else {
            return
        }
        AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
    }
    func playBeepSound() {
        AudioServicesPlaySystemSound(soundId)
    }
    // MARK: - ASRP31NSDK Delegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, searchingIP ip: String!, isFinish: Bool) {
        if isFinish == true {
            Utils.hiddenLoadingView()
            let array: Int = arrIPs.count
            if array > 0 {
                showAlertViewIPs()
            } else {
                Utils .showAlert("Search", message: "Not found Devices", view: self)
            }
        } else {
            arrIPs.add(ip)
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, change state: ASRP31NSDKNetworkState, error: Error!) {
        switch state {
        case .connected:
            enableUis(isEnable: false)
        case .disconnected:
            enableUis(isEnable: true)
        case .error:
            enableUis(isEnable: false)
            Utils .showAlert("Network", message: "Fail connected", view: self)
        default:
            break
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedPCEPCData pcEpc: Data!, selectAntena antenna: Int32) {
        guard let tag = pcEpc.hexadecimalString() else {
            return
        }
        print(tag)
        addScanDataFiltering(tag, rawData: pcEpc as NSData, selectAnt: antenna, RSSI: 0)
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedPCEPCData pcEpc: Data!, selectAntena antenna: Int32, rssi rssiVal: Int32) {
        guard let tag = pcEpc.hexadecimalString() else {
            return
        }
        addScanDataFiltering(tag, rawData: pcEpc as NSData, selectAnt: antenna, RSSI: rssiVal)
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, readerConnectedStatus statusCode: ASRP31NSDKCommonStatus) {
        switch statusCode {
        case .success:
            Utils .showAlert("Network Connected", message: "RFID did power ON", view: self)
            enableUis(isEnable: true)
        case .failure:
            Utils .showAlert("Error", message: "Failue Network connected.", view: self)
            enableUis(isEnable: false)
        default:
            break
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedStoppedReadTagsStatus statusCode: ASRP31NSDKCommonStatus) {
        switch statusCode {
        case .success:
            break
        case .failure:
            break
        default:
            break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTagTableView" {
            tagViewController = segue.destination as? TagViewController
        }
    }
}
