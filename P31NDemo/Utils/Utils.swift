//
//  Utils.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import SVProgressHUD

let dfTIMEOUTDEFAULT = 5
let dfTIMEOUTNONE = 0

class Utils: UIViewController {
    
    static var loagingMessage = ""
    class func showAlert(_ title: String, message: String, view: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            view.present(alert, animated: true, completion: nil)
            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    /*20190621  Response Time Out*/
    class func showLoadingView(_ message: String, timeOut: Int32) {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.dismiss()
            NSObject.cancelPreviousPerformRequests(withTarget: checkTimeOut)
            loagingMessage = message
            SVProgressHUD.show(withStatus: message)
            if timeOut > 0 {
                perform(#selector(checkTimeOut), with: nil, afterDelay: TimeInterval(timeOut))
            }
        }
    }
    
    /*20190621  Response Time Out*/
    class func hiddenLoadingView() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            NSObject.cancelPreviousPerformRequests(withTarget: checkTimeOut)
        }
    }
    
    /*20190621  Response Time Out*/
    @objc class func checkTimeOut() {
        DispatchQueue.main.async {
            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss()
                guard let pRootViewController = UIApplication.shared.keyWindow?.subviews[0].next as? UIViewController else {
                    return
                }
                let err = "Please check Connect\n[\(loagingMessage)]"
                Utils.showAlert("Response timeout", message: err, view: pRootViewController)
            }
        }
    }
}
