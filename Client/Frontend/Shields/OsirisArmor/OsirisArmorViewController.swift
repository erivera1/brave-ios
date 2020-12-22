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
        return shieldsView.simpleShieldView.shieldsSwitch
    }
    
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
//        self.view.backgroundColor = .yellow
        self.view.sendSubviewToBack(backgroundImageView)

//        shieldsView.osirisArmorView.hostLabel.text = url?.normalizedHost()
//        shieldsView.osirisArmorView.toggle.isOn = true
//        shieldsView.osirisArmorView.buttonTest.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
////        shieldsView.osirisArmorView.buttonTest.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        shieldsView.osirisArmorView.toggle.addTarget(self, action: #selector(osirisOverrideSwitchValueChanged), for: .valueChanged)
//
//        tab.contentBlocker.statsDidChange = { [weak self] _ in
//            self?.updateShieldBlockStats()
//        }
//        shieldsView.osirisArmorView.backgroundColor = .blue
//        self.view.bringSubviewToFront(shieldsView.osirisArmorView)
//
//        updateToggleStatus()
        updatePreferredContentSize()
//        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonPressed))
//        singleTapGesture.numberOfTapsRequired = 1
//        self.view.addGestureRecognizer(singleTapGesture)
//        let osirisAmorView = OsirisArmorView()
//        self.view.addSubview(osirisAmorView)
        
//        shieldsView.simpleShieldView.buttonTest.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
//        shieldsView.simpleShieldView.shieldsSwitch.addTarget(self, action: #selector(osirisOverrideSwitchValueChanged), for: .valueChanged)
        updateToggleStatus()
        
        shieldControlMapping.forEach { shield, toggle, option in
            toggle.valueToggled = { [unowned self] on in
                // Localized / per domain toggles triggered here
                self.updateBraveShieldState(shield: shield, on: on, option: option)
                // Wait a fraction of a second to allow DB write to complete otherwise it will not use the
                // updated shield settings when reloading the page
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.shieldsSettingsChanged?(self)
                }
            }
        }
    }
    
//    @objc private func shieldsOverrideSwitchValueChanged() {
//        let isOn = shieldsUpSwitch.isOn
//        self.updateGlobalShieldState(isOn, animated: true)
//        self.updateBraveShieldState(shield: .AllOff, on: isOn, option: nil)
//        // Wait a fraction of a second to allow DB write to complete otherwise it will not use the updated
//        // shield settings when reloading the page
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.shieldsSettingsChanged?(self)
//        }
//    }
    
//    private func updateToggleStatus() {
//        var domain: Domain?
//        if let url = url {
//            let isPrivateBrowsing = PrivateBrowsingManager.shared.isPrivateBrowsing
//            domain = Domain.getOrCreate(forUrl: url, persistent: !isPrivateBrowsing)
//        }
//
//        if let domain = domain {
//            shieldsView.simpleShieldView.setOn(!domain.isShieldExpected(.AllOff, considerAllShieldsOption: false), animated: true)
//            shieldsUpSwitch.isOn = !domain.isShieldExpected(.AllOff, considerAllShieldsOption: false)
//        } else {
//            shieldsView.simpleShieldView.setOn(true, animated: true)
//        }
//        
////        shieldControlMapping.forEach { shield, view, option in
////            // Updating based on global settings
////            if let option = option {
////                // Sets the default setting
////                view.toggleSwitch.isOn = option.value
////            }
////            // Domain specific overrides after defaults have already been setup
////
////            if let domain = domain {
////                // site-specific shield has been overridden, update
////                view.toggleSwitch.isOn = domain.isShieldExpected(shield, considerAllShieldsOption: false)
////            }
////        }
//        
//        updateGlobalShieldState(shieldsUpSwitch.isOn)
//    }
//    
    private func updateGlobalShieldState(_ on: Bool, animated: Bool = false) {
//        shieldsView.simpleShieldView.statusLabel.text = on ?
//            Strings.Shields.statusValueUp.uppercased() :
//            Strings.Shields.statusValueDown.uppercased()
        
        // Whether or not shields are available for this URL.
        let isShieldsAvailable = url?.isLocal == false
        // If shields aren't available, we don't show the switch and show the "off" state
        let shieldsEnabled = isShieldsAvailable ? on : false
        
        switchState(isOn: shieldsEnabled)
        if animated {
            var partOneViews: [UIView]
            var partTwoViews: [UIView]
            if shieldsEnabled {
                partOneViews = [self.shieldsView.simpleShieldView.shieldsDownStackView]
                partTwoViews = [
                    self.shieldsView.simpleShieldView.blockCountView,
                    self.shieldsView.simpleShieldView.footerLabel,
                    self.shieldsView.advancedControlsBar
                ]
//                if advancedControlsShowing {
//                    partTwoViews.append(self.shieldsView.advancedShieldView)
//                }
            } else {
                partOneViews = [
                    self.shieldsView.simpleShieldView.blockCountView,
                    self.shieldsView.simpleShieldView.footerLabel,
                    self.shieldsView.advancedControlsBar,
                ]
//                if advancedControlsShowing {
//                    partOneViews.append(self.shieldsView.advancedShieldView)
//                }
                partTwoViews = [self.shieldsView.simpleShieldView.shieldsDownStackView]
            }
            // Step 1, hide
            UIView.animate(withDuration: 0.1, animations: {
                partOneViews.forEach { $0.alpha = 0.0 }
            }, completion: { _ in
                partOneViews.forEach {
                    $0.alpha = 1.0
                    $0.isHidden = true
                }
                partTwoViews.forEach {
                    $0.alpha = 0.0
                    $0.isHidden = false
                }
                UIView.animate(withDuration: 0.15, animations: {
                    partTwoViews.forEach { $0.alpha = 1.0 }
                })

                self.updatePreferredContentSize()
            })
        } else {
//            shieldsView.simpleShieldView.blockCountView.isHidden = !shieldsEnabled
//            shieldsView.simpleShieldView.footerLabel.isHidden = !shieldsEnabled
//            shieldsView.simpleShieldView.shieldsDownStackView.isHidden = shieldsEnabled
//            shieldsView.advancedControlsBar.isHidden = !shieldsEnabled

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
            height: 360
        )
    }

    func updateShieldBlockStats() {
        shieldsView.osirisArmorView.adBlockLabel.text = String(
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
        shieldsView.simpleShieldView.setOn(isOn, animated: true)
        switchState(isOn: isOn)
    }
    
    func switchState(isOn: Bool) {
        if isOn {
            
//            DispatchQueue.main.async {
                self.shieldsView.simpleShieldView.armorImageView.image = UIImage(named: "amor_active")
                self.updateShieldBlockStats()
//            }
            
        } else {
//            DispatchQueue.main.async {
                self.shieldsView.simpleShieldView.armorImageView.image = UIImage(named: "armor_inactive")
                self.shieldsView.simpleShieldView.adBlockLabel.text = "0"
//            }
        }
        
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

extension OsirisArmorViewController {
    class View: UIView, Themeable {
        
        private let scrollView = UIScrollView().then {
            $0.delaysContentTouches = false
        }
        
        var contentView: UIView? {
            didSet {
                oldValue?.removeFromSuperview()
                if let view = contentView {
                    scrollView.addSubview(view)
                    view.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                }
            }
        }
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.isLayoutMarginsRelativeArrangement = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let osirisArmorView = OsirisArmorView()
        let simpleShieldView = SimpleShieldsView()
        let advancedControlsBar = AdvancedControlsBarView()
        let advancedShieldView = AdvancedShieldsView().then {
            $0.isHidden = true
        }
        
        let reportBrokenSiteView = ReportBrokenSiteView()
        let siteReportedView = SiteReportedView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            stackView.addArrangedSubview(simpleShieldView)
            stackView.addArrangedSubview(osirisArmorView)
//            stackView.addArrangedSubview(advancedControlsBar)
//            stackView.addArrangedSubview(advancedShieldView)
            
            addSubview(scrollView)
            scrollView.addSubview(stackView)
            
            scrollView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            scrollView.contentLayoutGuide.snp.makeConstraints {
                $0.left.right.equalTo(self)
            }
            
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            contentView = stackView
        }
        
        func applyTheme(_ theme: Theme) {
            simpleShieldView.applyTheme(theme)
            advancedControlsBar.applyTheme(theme)
            advancedShieldView.applyTheme(theme)
            reportBrokenSiteView.applyTheme(theme)
            siteReportedView.applyTheme(theme)
            
            backgroundColor = theme.isDark ? BraveUX.popoverDarkBackground : UIColor.white
        }
        
        @available(*, unavailable)
        required init(coder: NSCoder) {
            fatalError()
        }
    }
}

//extension ShieldsViewController {
//
//    var closeActionAccessibilityLabel: String {
//        return Strings.Popover.closeShieldsMenu
//    }
//}
