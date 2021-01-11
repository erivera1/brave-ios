// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Shared
import SnapKit
import BraveShared
import Data

class OsirisTopToolbarView: TopToolbarView {
//    var delegateOsiris: OsirisTabLocationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.refreshShieldsStatus()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshShieldsStatus() {
        // Default on
        var shieldIcon = "Osiris_Adsblocking_enabled"
        let shieldsOffIcon = "Osiris_Adsblocking_disabled"
        if let currentURL = currentURL {
            let isPrivateBrowsing = PrivateBrowsingManager.shared.isPrivateBrowsing
            let domain = Domain.getOrCreate(forUrl: currentURL, persistent: !isPrivateBrowsing)
            OsirisHelper().sitesToDisableBlocking(url: currentURL)
            if domain.shield_allOff == 1 {
                shieldIcon = shieldsOffIcon
            }
            if currentURL.isLocal || currentURL.isLocalUtility {
                shieldIcon = shieldsOffIcon
            }
        } else {
            shieldIcon = shieldsOffIcon
        }
        
        locationView.shieldsButton.setImage(UIImage(imageLiteralResourceName: shieldIcon), for: .normal)
    }
}
