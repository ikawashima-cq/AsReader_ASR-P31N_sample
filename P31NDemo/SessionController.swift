//
//  SessionController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class SessionController: UITableViewController, ASRP31NSDKDelegate {
    private var selectedSession: Int! = 0
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ASRP31NSDK.sharedInstance().delegate = self
        perform(#selector(onTickGetSession), with: nil, afterDelay: 0.4)
        Utils.showLoadingView("Searching Device", timeOut: Int32(dfTIMEOUTDEFAULT))
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ASRP31NSDK.sharedInstance().delegate = nil
    }
    // MARK: - IBAction
    @IBAction func btnSetSession(_ sender: Any) {
        guard let error = ASRP31NSDK.sharedInstance()?.setSession(__uint8_t(selectedSession)) else {
            return
        }
        print("\(#function)\n code = \(Int32(error._code))\n\(String(describing: error._userInfo))")
    }
    // MARK: - Private Method
    @objc func onTickGetSession() {
        Utils.hiddenLoadingView()
        let error = ASRP31NSDK.sharedInstance().getSession()
        guard let err: Error = error as Error? else {
            return
        }
        let string = err._userInfo
        let aaa: Int = string?.count ?? 0
        if aaa != 0 {
            print("\(#function)\n code = \(err._code)\n\(String(describing: err._userInfo))")
        }
    }
    // MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.text = "S\(Int32(indexPath.row))"
        if selectedSession == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSession = indexPath.row
        self.tableView.reloadData()
    }
    // MARK: - ASRP31NSDK Delegate
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedDidSetSessionState statusCode: ASRP31NSDKCommonStatus) {
        switch statusCode {
        case .success:
            Utils.showAlert("Success", message: "Session changed", view: self)
        case .failure:
            Utils.showAlert("Fail", message: "Session changed", view: self)
        default:
            break
        }
    }
    func asrp31N(_ ASRP31N: ASRP31NSDK!, receivedSession session: UInt8) {
        selectedSession = Int(session)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            Utils.hiddenLoadingView()
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
