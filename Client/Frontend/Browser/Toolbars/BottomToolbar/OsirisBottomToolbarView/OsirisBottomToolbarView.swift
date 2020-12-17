// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import SnapKit
import Shared
import BraveShared

/*
    PREPARATION FOR THE CUSTOM BOTTOMTOOLBAR
    ICONS ARE IN ToolbarHelper
    DELEGATE IMPELEMNTATION ARE IN BrowserViewController
*/
class OsirisBottomToolbarView: BottomToolbarView {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        contentView = UIStackView()
        actionButtons = [backButton, forwardButton, tabsButton, addTabButton, searchButton, menuButton]
        setupAccessibility()

        addSubview(contentView)
        helper = OsirisToolbarHelper(toolbar: self)
        addButtons(actionButtons)
        contentView.axis = .horizontal
        contentView.distribution = .fillEqually
        
//        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didSwipeToolbar(_:))))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAccessibility() {
        backButton.accessibilityIdentifier = "TabToolbar.backButton"
        forwardButton.accessibilityIdentifier = "TabToolbar.forwardButton"
        tabsButton.accessibilityIdentifier = "TabToolbar.tabsButton"
        shareButton.accessibilityIdentifier = "TabToolbar.shareButton"
        addTabButton.accessibilityIdentifier = "TabToolbar.addTabButton"
        searchButton.accessibilityIdentifier = "TabToolbar.searchButton"
        accessibilityNavigationStyle = .combined
        accessibilityLabel = Strings.tabToolbarAccessibilityLabel
    }
}
