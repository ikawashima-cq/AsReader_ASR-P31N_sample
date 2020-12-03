//
//  NetworkSettingController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class NetworkSettingController: UIViewController, ASRP31NSDKDelegate {
    var arryDeviceInfo: NSArray = NSArray()
    @IBOutlet private weak var viewStatic: UIView!
    @IBOutlet private weak var txtFieldIP: UITextField!
    @IBOutlet private weak var txtFieldSubnet: UITextField!
    @IBOutlet private weak var txtFieldGateWay: UITextField!
    @IBOutlet private weak var txtFieldDnsServer: UITextField!
    @IBOutlet private weak var txtFieldMacAddr: UITextField!
    @IBOutlet private weak var segmentDHCPStatic: UISegmentedControl!
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ASRP31NSDK.sharedInstance().delegate = self
        searchDevice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - IBAction
    @IBAction func searchButtonAction(_ sender: Any) {
        searchDevice()
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        let selectIndex = segmentDHCPStatic.selectedSegmentIndex
        let mac = txtFieldMacAddr.text
        let ip = txtFieldIP.text
        let sub = txtFieldSubnet.text
        let gw = txtFieldGateWay.text
        let dns = txtFieldDnsServer.text
        if selectIndex == 0 {
            ASRP31NSDK.sharedInstance()?.setDHCPOnMac(mac)
        } else if selectIndex == 1 {
            ASRP31NSDK.sharedInstance()?.setDHCPOffMac(mac, ip: ip, subnet: sub, gateWay: gw, dnsServer: dns)
        }
        Utils.showAlert("Confirm", message: "The network has changed.Press the [Search again] button and check the changed information.", view: self)
    }
    @IBAction func segmentButtonAction(_ sender: Any) {
        let selectIndex = segmentDHCPStatic.selectedSegmentIndex
        if selectIndex == 0 {
            self.enableTextField(false)
        } else if selectIndex == 1 {
            self.enableTextField(true)
        } else {
            
        }
    }
    // MARK: - PrivateMethod
    @objc func onTickHiddenAlert() {
        Utils.hiddenLoadingView()
    }
    func searchDevice() {
        ASRP31NSDK.sharedInstance().startSearchDevice()
        Utils.showLoadingView("Searching Device", timeOut: Int32(dfTIMEOUTNONE))
        perform(#selector(onTickHiddenAlert), with: nil, afterDelay: 5.0)
    }
    func enableTextField(_ isOn: Bool) {
        txtFieldMacAddr.isEnabled = isOn
        txtFieldIP.isEnabled = isOn
        txtFieldSubnet.isEnabled = isOn
        txtFieldGateWay.isEnabled = isOn
        txtFieldDnsServer.isEnabled = isOn
    }
    func showAlertViewAllDevics() {
        let alert = UIAlertController(title: "[Found Device] For DHCP ", message: "Please select device IP", preferredStyle: .actionSheet)
        for value in arryDeviceInfo {
            let device = value as? NSDictionary
            let sIp =  device?.value(forKey: "ip")
            let ip = UIAlertAction(title: sIp as? String, style: .default, handler: { (_) in
                self.txtFieldIP.text = device?.value(forKey: "ip") as? String
                self.txtFieldSubnet.text = device?.value(forKey: "subnet") as? String
                self.txtFieldGateWay.text = device?.value(forKey: "gateway") as? String
                self.txtFieldDnsServer.text = device?.value(forKey: "dns") as? String
                self.txtFieldMacAddr.text = device?.value(forKey: "mac") as? String
                let mode = device?.value(forKey: "dhcp") as? String
                let modeStr: String = mode ?? ""
                if modeStr == "DHCP" {
                    self.segmentDHCPStatic.selectedSegmentIndex = 0
                    self.enableTextField(false)
                } else {
                    self.segmentDHCPStatic.selectedSegmentIndex = 1
                    self.enableTextField(true)
                }
            })
            alert.addAction(ip)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - ASRP31NSDK Delegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, searchedUPDSearchingDeviceInfo arrInfos: [Any]!) {
        Utils.hiddenLoadingView()
        guard let array: NSArray = arrInfos as NSArray? else {
            return
        }
        arryDeviceInfo = array
        showAlertViewAllDevics()
    }
    
    func asrp31N(_ ASRP31N: ASRP31NSDK!, searchingIP ip: String!, isFinish: Bool) {
        if isFinish == true {
            Utils.hiddenLoadingView()
        }
    }
}
