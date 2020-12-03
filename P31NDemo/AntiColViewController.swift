//
//  AntiColViewController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class AntiColViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ASRP31NSDKDelegate {
    @IBOutlet private weak var myTableView: UITableView!
    private var modeList: [String] = ["MODE 0", "MODE 1", "MODE 2", "MODE 3", "MODE 4", "MODE 5", "MODE 6"]
    private var selectedMode: Int!
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ASRP31NSDK.sharedInstance().delegate = self
        ASRP31NSDK.sharedInstance().getAnticollision()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - UITableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.text = modeList[indexPath.row]
        if selectedMode == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index: Int = 0
        for value in modeList {
            print(value)
            let cell = myTableView?.cellForRow(at: NSIndexPath(row: index, section: 0) as IndexPath)
            if index == indexPath.row {
                cell?.accessoryType = .checkmark
                selectedMode = indexPath.row
            } else {
                cell?.accessoryType = .none
            }
            index += 1
        }
    }
    // MARK: - IBAction
    @IBAction func done(_ sender: Any) {
        ASRP31NSDK.sharedInstance()?.setAnticollision(__uint8_t(selectedMode))
    }
    // MARK: - ASRP31NSDKDelegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedAnticollison param: UInt8) {
        selectedMode = Int(param)
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedDidSetAntiCollision statusCode: UInt8) {
        switch statusCode {
        case UInt8(ASRP31NSDKCommonStatus.success.rawValue):
            Utils.showAlert("Success", message: "Anticollison Mode changed", view: self)
        case UInt8(ASRP31NSDKCommonStatus.failure.rawValue):
            Utils.showAlert("Fail", message: "Anticollison Mode changed", view: self)
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
