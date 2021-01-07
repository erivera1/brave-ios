// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import Storage
import SnapKit
import XCGLogger
import MobileCoreServices
import SwiftyJSON
import Data

class OsirisBrowserViewController: BrowserViewController {

    private let backgroundImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundImageView)
        view.backgroundColor = UIColor.white
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.image = UIImage(named: OsirisConstants.backGroundImage)
        
//        // TRUE - the user can choose if he wants to update now or later by calling
        CheckUpdate.shared.showUpdate(withConfirmation: true)
        updateTabsBarVisibility()
    }
    
    override func updateTabsBarVisibility() {
        tabsBar.view.isHidden = true
    }
}

