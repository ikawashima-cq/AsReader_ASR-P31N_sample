//
//  ReadWriteController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class ReadWriteController: UIViewController, UITextFieldDelegate, ASRP31NSDKDelegate {
    @IBOutlet private weak var olMode: UISegmentedControl!
    @IBOutlet private weak var olAccessPassword: UITextField!
    @IBOutlet private weak var olStartAdress: UITextField!
    @IBOutlet private weak var olLength: UITextField!
    @IBOutlet private weak var olData: UITextField!
    @IBOutlet private weak var olTargetMemory: UISegmentedControl!
    @IBOutlet private weak var olTargetEpc: UITextField!
    @IBOutlet private weak var olDataTitle: UILabel!
    @IBOutlet private weak var olScrollVeiw: UIScrollView!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.olScrollVeiw.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+600)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIApplication.keyboardWillShowNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let selectTag = SelectedTagInfo.sharedDanli()
        self.olTargetEpc.text = selectTag.selectedTagEPC
        ASRP31NSDK.sharedInstance().delegate = self
        self.olAccessPassword.delegate = self
        self.olStartAdress.delegate = self
        self.olLength.delegate = self
        self.olData.delegate = self
        self.olTargetEpc.delegate = self
    }
    // MARK: - PrivateMethod
    func dataToEpcInteger(_ data: Data) -> String {
        var pData: [UInt8] = data.toBytes
        var intData: Int = Int(pData[0])<<8|Int(pData[1])
        intData = intData>>11
        return "\(intData)"
    }
    func setViewMoveUp(_ moveUp: Bool) {
        if moveUp {
            UIView.animate(withDuration: 0.2, animations: {
                self.olScrollVeiw.contentOffset = CGPoint(x: 0.0, y: 100.0)
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.olScrollVeiw.contentOffset = CGPoint(x: 0.0, y: self.olScrollVeiw.frame.origin.y)
            })
        }
    }
    @objc func keyboardWillShow(_ notif: NSNotification) {
        let aaa: Bool = self.olData.isFirstResponder
        if aaa == true {
           if self.view.frame.origin.y >= 0 {
                setViewMoveUp(true)
            } else if self.view.frame.origin.y < 0 {
                setViewMoveUp(false)
            }
        }
    }
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ txtField: UITextField) -> Bool {
        setViewMoveUp(false)
        txtField.resignFirstResponder()
        return false
    }
    // MARK: - IBAction
    @IBAction func eModeChanged(_ sender: Any) {
        if self.olMode.selectedSegmentIndex == 0 {
            self.navigationItem.title = "Read"
        } else {
            self.navigationItem.title = "Write"
        }
    }
    @IBAction func rightBarButtonItemClicked(_ sender: Any) {
        self.olTargetEpc.resignFirstResponder()
        self.olAccessPassword.resignFirstResponder()
        self.olStartAdress.resignFirstResponder()
        self.olLength.resignFirstResponder()
        self.olData.resignFirstResponder()
        setViewMoveUp(false)
        let hexaString = self.olAccessPassword.text ?? ""
        var accesspassword: UInt32 = 0
        Scanner(string: hexaString).scanHexInt32(&accesspassword)
        let aaa: String = self.olStartAdress.text ?? ""
        let startAddress = Int32(aaa)
        let bbb: String = self.olLength.text ?? ""
        let dataLength = Int32(bbb)
        var membank: __uint8_t = 0
        switch self.olTargetMemory.selectedSegmentIndex {
        case 0:
            membank = 0
        case 1:
            membank = 1
        case 2:
            membank = 1
        case 3:
            membank = 2
        case 4:
            membank = 3
        default: break
        }
        guard var data: NSData = self.olData.text?.hexStringToBytes() else {
            return
        }
        guard let epcs: NSData = self.olTargetEpc.text?.hexStringToBytes() else {
            return
        }
        let pcData = epcs.subdata(with: NSRange(location: 0, length: 2))
        if epcs.length == 0 {
            return
        }
        let staAdd = __uint16_t(startAddress ?? 0)
        let dateLen =  __uint16_t(dataLength ?? 0)
        if self.olMode.selectedSegmentIndex == 0 {
            ASRP31NSDK.sharedInstance().read(fromTagMemory: __uint32_t(accesspassword), epc: (epcs as Data), memoryBank: UInt8(membank), startAddress: staAdd, dataLength: dateLen)
           
        } else {
            if self.olTargetMemory.selectedSegmentIndex == 1 {
                var pData: [UInt8] = pcData.toBytes
                var intData: Int = Int(pData[0])<<8|Int(pData[1])
                guard let value = self.olData.text else {
                    return
                }
                guard let epcLength = Int32(value) else {
                    return
                }
                if epcLength != 0 {
                    intData = intData&0x07FF
                    intData = intData|Int((epcLength&0x1F) << 11)
                }
                data = String(format: "%04X", intData).hexStringToBytes()
            }
            ASRP31NSDK.sharedInstance()?.setWriteToTagMemory(__uint32_t(accesspassword), epc: epcs as Data, memoryBank: UInt8(membank), startAddress: staAdd, dataToWrite: data as Data)
        }
    }
    @IBAction func eTargetMemoryChanged(_ sender: Any) {
        self.olDataTitle.text = "Data (HEX)"
        self.olData.resignFirstResponder()
        self.olData.keyboardType = .default
        if self.olTargetMemory.selectedSegmentIndex == 1 {
            //PC
            self.olStartAdress.text = "1"
            self.olLength.text = "1"
            self.olStartAdress.isEnabled = false
            self.olLength.isEnabled = false
            self.olDataTitle.text = "EPC Length"
            self.olData.keyboardType = .numberPad
        } else if self.olTargetMemory.selectedSegmentIndex == 2 {
            //EPC
            self.olStartAdress.text = "2"
            self.olLength.text = "0"
            self.olStartAdress.isEnabled = false
            self.olLength.isEnabled = false
        } else {
            self.olStartAdress.isEnabled = true
            self.olLength.isEnabled = true
        }
    }
    @IBAction func actLimitEPCLength(_ sender: Any) {
        if self.olTargetMemory.selectedSegmentIndex == 1 {
            let str: String = self.olData.text ?? ""
            let aaa: Int = Int(str) ?? 0
            if aaa > 31 {
                self.olData.text = "31"
            }
        }
    }
    // MARK: - ASRP31NSDKDelegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedTagMemory data: Data!) {
        DispatchQueue.main.async {
            var strData = ""
            if self.olTargetMemory.selectedSegmentIndex == 1 {
                print(data)
                strData = self.dataToEpcInteger(data)
            } else {
                strData = data.hexadecimalString() ?? ""
            }
            self.olData.text = strData
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedWritedStatus statusCode: ASRP31NSDKCommonStatus) {
        switch statusCode {
        case .success:
            Utils.showAlert("Success", message: "Writed", view: self)
        case .failure:
            Utils.showAlert("Fail", message: "Writed", view: self)
        default:
            break
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedErrDetail errCode: Data!) {
        guard let tag = errCode.hexadecimalString() else {
            return
        }
        let errMessage: String = "\(tag)"
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
