//
//  TagViewController.swift
//  P31NDemo
//
//  Created by mac on 2019/7/16.
//  Copyright © 2019年 quzhonggen. All rights reserved.
//

import UIKit

class TagViewController: UITableViewController {

    private var accessoryList = NSMutableArray()
    private var tagData = TagData.shared()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func updateData() {
        DispatchQueue.main.async {
           self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int = tagData?.arrTags.count ?? 0
        return count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {
           return UITableViewCell()
        }
        guard let dic: NSDictionary = tagData?.arrTags.object(at: indexPath.row) as? NSDictionary else {
            return UITableViewCell()
        }
        guard let epEpc: String = dic.value(forKey: dfCELLTAGINFO) as? String else {
            return UITableViewCell()
        }
        cell.setTagHex(epEpc)
        guard let ant = dic.value(forKey: dfCELLTAGANT) else {
            return UITableViewCell()
        }
        cell.setTagAnt("ANT : \(String(describing: ant))")
        guard let count = dic.value(forKey: dfCELLTAGCOUNT)  as? String else {
            return UITableViewCell()
        }
        cell.setTagCount(count)
        
        let isRSSIOn = UserDefaults.standard.bool(forKey: "RSSI")
        
        guard let strRSSI = dic.value(forKey: dfCELLTAGRSSI) as? String else {
            return UITableViewCell()
        }
        if isRSSIOn == true {
            cell.setTagRSSI(" RSSI : \(String(describing: strRSSI))")
        } else {
            cell.setTagRSSI("")
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectTag: SelectedTagInfo = SelectedTagInfo.sharedDanli()
        let dict = tagData?.arrTags.object(at: indexPath.row)
        let dic = dict as? NSDictionary
        let pcEpc = dic?.value(forKey: dfCELLTAGRAW)
        guard let newpcEpc: Data = pcEpc as? Data else {
            return
        }
        let tag = newpcEpc.epcString()
        selectTag.selectedTagEPC = tag ?? ""
        let tagView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_TagAcessView")
        self.navigationController?.pushViewController(tagView, animated: true)
    }
}
