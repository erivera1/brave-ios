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
    var delegateOsiris: OsirisTabLocationViewDelegate?
    
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

// MARK: - TabLocationViewDelegate

extension OsirisTopToolbarView: OsirisTabLocationViewDelegate {
    func tabLocationViewDidTapStop(_ tabLocationView: OsirisTabLocationView) {
        delegate?.topToolbarDidPressStop(self)
    }
    
    func tabLocationViewDidTapShieldsButton(_ urlBar: OsirisTabLocationView) {
        delegate?.topToolbarDidTapBraveShieldsButton(self)
    }
    
    func tabLocationViewDidTapRewardsButton(_ urlBar: OsirisTabLocationView) {
        delegate?.topToolbarDidTapBraveRewardsButton(self)
    }
    
    func tabLocationViewDidLongPressRewardsButton(_ urlBar: OsirisTabLocationView) {
        delegate?.topToolbarDidLongPressBraveRewardsButton(self)
    }
    
    func tabLocationViewDidLongPressReaderMode(_ tabLocationView: OsirisTabLocationView) -> Bool {
        return delegate?.topToolbarDidLongPressReaderMode(self) ?? false
    }
    
    func tabLocationViewDidTapLocation(_ tabLocationView: OsirisTabLocationView) {
        guard let (locationText, isSearchQuery) = delegate?.topToolbarDisplayTextForURL(locationView.url as URL?) else { return }
        
        var overlayText = locationText
        // Make sure to use the result from topToolbarDisplayTextForURL as it is responsible for extracting out search terms when on a search page
        if let text = locationText, let url = URL(string: text), let host = url.host {
            overlayText = url.absoluteString.replacingOccurrences(of: host, with: host.asciiHostToUTF8())
        }
        enterOverlayMode(overlayText, pasted: false, search: isSearchQuery)
    }
    
    func tabLocationViewDidLongPressLocation(_ tabLocationView: OsirisTabLocationView) {
        delegate?.topToolbarDidLongPressLocation(self)
    }
    
    func tabLocationViewDidTapReload(_ tabLocationView: OsirisTabLocationView) {
        delegate?.topToolbarDidPressReload(self)
    }
    
//    func tabLocationViewDidTapStop(_ tabLocationView: TabLocationView) {
//        delegate?.topToolbarDidPressStop(self)
//    }
    
    func tabLocationViewDidLongPressReload(_ tabLocationView: OsirisTabLocationView, from button: UIButton) {
        delegate?.topToolbarDidLongPressReloadButton(self, from: button)
        delegate?.topToolbarDidLongPressLocation(self)
    }

    func tabLocationViewDidTapReaderMode(_ tabLocationView: OsirisTabLocationView) {
        delegate?.topToolbarDidPressReaderMode(self)
    }

    func tabLocationViewLocationAccessibilityActions(_ tabLocationView: OsirisTabLocationView) -> [UIAccessibilityCustomAction]? {
        return delegate?.topToolbarLocationAccessibilityActions(self)
    }
    
    func tabLocationViewDidBeginDragInteraction(_ tabLocationView: OsirisTabLocationView) {
        delegate?.topToolbarDidBeginDragInteraction(self)
    }
}

