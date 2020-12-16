// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

class OsirisSettingsViewController: SettingsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: OsirisConstants.backGroundImage)
        // Do any additional setup after loading the view.
//        tableView.backgroundView = backgroundImageView
//        tableView.backgroundColor = UIColor.clear
        
//        tableView.dataSource = self
//        self.view.backgroundColor = UIColor.red
//        tableView.backgroundView?.backgroundColor = UIColor.purple
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}
//extension OsirisSettingsViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(sections[section].rows.count)
//        return sections[section].rows.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = UIColor.clear
//        return cell
//    }
//}
