// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import Shared
class OsirisToolbarHelper: ToolbarHelper {
//    let toolbar: ToolbarProtocol
    
    override init(toolbar: ToolbarProtocol) {
        
        super.init(toolbar: toolbar)
        self.toolbar = toolbar
        toolbar.backButton.setImage(#imageLiteral(resourceName: "chevron-thin-left").template, for: .normal)
        toolbar.backButton.accessibilityLabel = Strings.tabToolbarBackButtonAccessibilityLabel
        let longPressGestureBackButton = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressBack))
        toolbar.backButton.addGestureRecognizer(longPressGestureBackButton)
        toolbar.backButton.addTarget(self, action: #selector(didClickBack), for: .touchUpInside)

        toolbar.tabsButton.tintColor = .clear
        toolbar.tabsButton.addTarget(self, action: #selector(didClickTabs), for: .touchUpInside)
        let longPressGestureTabsButton = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressTabs))
        toolbar.tabsButton.addGestureRecognizer(longPressGestureTabsButton)
        
        
        toolbar.shareButton.setImage(#imageLiteral(resourceName: "nav-share").template, for: .normal)
        toolbar.shareButton.accessibilityLabel = Strings.tabToolbarShareButtonAccessibilityLabel
        toolbar.shareButton.addTarget(self, action: #selector(didClickShare), for: UIControl.Event.touchUpInside)
        
        toolbar.addTabButton.setImage(#imageLiteral(resourceName: "add_tab").template, for: .normal)
        toolbar.addTabButton.accessibilityLabel = Strings.tabToolbarAddTabButtonAccessibilityLabel
        toolbar.addTabButton.addTarget(self, action: #selector(didClickAddTab), for: UIControl.Event.touchUpInside)
        toolbar.addTabButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPressAddTab(_:))))
        
        toolbar.searchButton.setImage(#imageLiteral(resourceName: "ntp-search").template, for: .normal)
        // Accessibility label not needed, since overriden in the bottom tool bar class.
        toolbar.searchButton.addTarget(self, action: #selector(didClickSearch), for: UIControl.Event.touchUpInside)
        // Same long press gesture allows creating tab on NTP, esp private tab easily
        toolbar.searchButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPressAddTab(_:))))

        toolbar.menuButton.setImage(#imageLiteral(resourceName: "reader").template, for: .normal)
        toolbar.menuButton.accessibilityLabel = Strings.tabToolbarMenuButtonAccessibilityLabel
        toolbar.menuButton.addTarget(self, action: #selector(didClickMenu), for: UIControl.Event.touchUpInside)
        
        toolbar.forwardButton.setImage(#imageLiteral(resourceName: "chevron-thin-right").template, for: .normal)
        toolbar.forwardButton.accessibilityLabel = Strings.tabToolbarForwardButtonAccessibilityLabel
        let longPressGestureForwardButton = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressForward))
        toolbar.forwardButton.addGestureRecognizer(longPressGestureForwardButton)
        toolbar.forwardButton.addTarget(self, action: #selector(didClickForward), for: .touchUpInside)
    }
}
