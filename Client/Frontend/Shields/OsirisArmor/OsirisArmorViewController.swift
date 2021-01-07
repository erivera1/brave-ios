// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import Storage
import SnapKit
import Shared
import BraveShared
import Data
import BraveUI

class OsirisArmorViewController: ShieldsViewController {

    private lazy var shieldControlMapping: [(BraveShield, AdvancedShieldsView.ToggleView, Preferences.Option<Bool>?)] = [
        (.AdblockAndTp, shieldsView.advancedShieldView.adsTrackersControl, Preferences.Shields.blockAdsAndTracking),
        (.SafeBrowsing, shieldsView.advancedShieldView.blockMalwareControl, Preferences.Shields.blockPhishingAndMalware),
        (.NoScript, shieldsView.advancedShieldView.blockScriptsControl, Preferences.Shields.blockScripts),
        (.HTTPSE, shieldsView.advancedShieldView.httpsUpgradesControl, Preferences.Shields.httpsEverywhere),
        (.FpProtection, shieldsView.advancedShieldView.fingerprintingControl, Preferences.Shields.fingerprintingProtection),
    ]
    
    private var shieldsUpSwitch: ShieldsSwitch {
        return shieldsView.simpleShieldView.osirisArmorView.shieldsSwitch
    }
    
    private func updateOsirisShieldBlockStats() {
        shieldsView.simpleShieldView.osirisArmorView.adBlockLabel.text = String(
            tab.contentBlocker.stats.adCount +
            tab.contentBlocker.stats.trackerCount +
            tab.contentBlocker.stats.httpsCount +
            tab.contentBlocker.stats.scriptCount +
            tab.contentBlocker.stats.fingerprintingCount
        )
    }
    
//    override init(tab: Tab) {
//        self.tab = tab
//        
//        super.init(nibName: nil, bundle: nil)
//        
//        tab.contentBlocker.statsDidChange = { [weak self] _ in
//            self?.updateOsirisShieldBlockStats()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        osirisOverrideSwitchValueChanged()
//        shieldsView.osirisArmorView.isUserInteractionEnabled = true
//        self.view.isUserInteractionEnabled = true
//        shieldsView.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
//        shieldsView.simpleShieldView.isHidden = true
//        shieldsView.osirisArmorView.isHidden = true
//        shieldsView.simpleShieldView.blockCountView.isHidden = true
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: OsirisConstants.backGroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.view.sendSubviewToBack(backgroundImageView)

//        updatePreferredContentSize()
//
//        updateOsirisShieldBlockStats()
//        navigationController?.setNavigationBarHidden(true, animated: false)
//
//        updateToggleStatus()
//
//        shieldControlMapping.forEach { shield, toggle, option in
//            toggle.valueToggled = { [unowned self] on in
//                // Localized / per domain toggles triggered here
//                self.updateBraveShieldState(shield: shield, on: on, option: option)
//                // Wait a fraction of a second to allow DB write to complete otherwise it will not use the
//                // updated shield settings when reloading the page
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    self.shieldsSettingsChanged?(self)
//                }
//            }
//        }
        if let url = url {
            if url.absoluteString.contains("naver") || url.absoluteString.contains("daum") {
                shieldsView.simpleShieldView.osirisArmorView.shieldsSwitch.isEnabled = false
            }
        }
        shieldsView.simpleShieldView.osirisArmorView.shieldsSwitch.addTarget(self, action: #selector(osirisOverrideSwitchValueChanged), for: .valueChanged)
        shieldsView.simpleShieldView.osirisArmorView.hostLabel.text = url?.normalizedHost()
    }
    
    internal override func updateToggleStatus() {
        var domain: Domain?
        if let url = url {
            let isPrivateBrowsing = PrivateBrowsingManager.shared.isPrivateBrowsing
            domain = Domain.getOrCreate(forUrl: url, persistent: !isPrivateBrowsing)
        }

        if let domain = domain {
            shieldsView.simpleShieldView.osirisArmorView.setOn(!domain.isShieldExpected(.AllOff, considerAllShieldsOption: false), animated: true)
            shieldsUpSwitch.isOn = !domain.isShieldExpected(.AllOff, considerAllShieldsOption: false)
        } else {
            shieldsView.simpleShieldView.osirisArmorView.setOn(true, animated: true)
        }
        
        shieldControlMapping.forEach { shield, view, option in
            // Updating based on global settings
            if let option = option {
                // Sets the default setting
                view.toggleSwitch.isOn = option.value
            }
            // Domain specific overrides after defaults have already been setup

            if let domain = domain {
                // site-specific shield has been overridden, update
                view.toggleSwitch.isOn = domain.isShieldExpected(shield, considerAllShieldsOption: false)
            }
        }
        
        updateGlobalShieldState(shieldsUpSwitch.isOn)
    }
  
    private func updateGlobalShieldState(_ on: Bool, animated: Bool = false) {

        // Whether or not shields are available for this URL.
        let isShieldsAvailable = url?.isLocal == false
        // If shields aren't available, we don't show the switch and show the "off" state
        let shieldsEnabled = isShieldsAvailable ? on : false
        shieldsView.simpleShieldView.osirisArmorView.setOn(shieldsEnabled, animated: false)
        if animated {
            let partOneViews: [UIView]
            let partTwoViews: [UIView]
            if shieldsEnabled {
                partOneViews = [self.shieldsView.simpleShieldView.shieldsDownStackView]
                partTwoViews = [
                    self.shieldsView.simpleShieldView.blockCountView,
                    self.shieldsView.simpleShieldView.footerLabel,
                    self.shieldsView.advancedControlsBar
                ]
                
                updateOsirisShieldBlockStats()
            } else {
                partOneViews = [
                    self.shieldsView.simpleShieldView.blockCountView,
                    self.shieldsView.simpleShieldView.footerLabel,
                    self.shieldsView.advancedControlsBar,
                ]
                
                partTwoViews = [self.shieldsView.simpleShieldView.shieldsDownStackView]
            }

        } else {

            updatePreferredContentSize()
        }
    }
    
    func updatePreferredContentSize() {
//        guard let visibleView = shieldsView.contentView else { return }
        let width = min(360, UIScreen.main.bounds.width - 20)
        // Ensure the a static width is given to the main view so we can calculate the height
        // correctly when we force a layout
        shieldsView.frame = CGRect(origin: .zero, size: .init(width: width, height: 0))
        shieldsView.setNeedsLayout()
        shieldsView.layoutIfNeeded()
        preferredContentSize = CGSize(
            width: width,
            height: 380
        )
    }

    func updateShieldBlockStats() {
        shieldsView.simpleShieldView.osirisArmorView.adBlockLabel.text = String(
            tab.contentBlocker.stats.adCount +
            tab.contentBlocker.stats.trackerCount +
            tab.contentBlocker.stats.httpsCount +
            tab.contentBlocker.stats.scriptCount +
            tab.contentBlocker.stats.fingerprintingCount
        )
    }
    
    @objc override func buttonPressed() {
        print("hello test")
    }
    //OSIRIS ARMOR
    @objc private func osirisOverrideSwitchValueChanged() {
        let isOn = shieldsUpSwitch.isOn
        shieldsView.simpleShieldView.osirisArmorView.setOn(isOn, animated: true)
//        switchState(isOn: isOn)
        self.updateGlobalShieldState(isOn, animated: true)
        self.updateBraveShieldState(shield: .AllOff, on: isOn, option: nil)
        // Wait a fraction of a second to allow DB write to complete otherwise it will not use the updated
        // shield settings when reloading the page
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.shieldsSettingsChanged?(self)
        }
    }
    
    private func updateBraveShieldState(shield: BraveShield, on: Bool, option: Preferences.Option<Bool>?) {
        guard let url = url else { return }
        let allOff = shield == .AllOff
        // `.AllOff` uses inverse logic. Technically we set "all off" when the switch is OFF, unlike all the others
        // If the new state is the same as the global preference, reset it to nil so future shield state queries
        // respect the global preference rather than the overridden value. (Prevents toggling domain state from
        // affecting future changes to the global pref)
        let isOn = allOff ? !on : on
        Domain.setBraveShield(forUrl: url, shield: shield, isOn: isOn,
                              isPrivateBrowsing: PrivateBrowsingManager.shared.isPrivateBrowsing)
    }
}

