// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import Shared
import BraveShared
import BraveUI

class SimpleShieldsView: UIView, Themeable {
    
    var armorImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "amor_active")
        $0.snp.makeConstraints {
            $0.width.equalTo(160)
            $0.height.equalTo(140)
        }
        $0.layer.cornerRadius = 4
        if #available(iOS 13.0, *) {
            $0.layer.cornerCurve = .continuous
        }
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
    }
    
    let urlView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let hostTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12.0)
        $0.text = "Armor Settings For :"
        $0.textColor = .green
        $0.backgroundColor = .clear
    }
    
    var hostLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12.0)
        $0.text = "www.yehey.com"
        $0.backgroundColor = .clear
    }
    
    var adsCountView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    let adsBloclImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "adsBlockIcon")
        $0.snp.makeConstraints {
            $0.size.equalTo(60)
        }
        $0.layer.cornerRadius = 4
        if #available(iOS 13.0, *) {
            $0.layer.cornerCurve = .continuous
        }
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
    }
    
    let adBlockTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12.0)
        $0.numberOfLines = 2
        $0.text = "Ads, Trackers, Scripts and other creepy things blocked"
        $0.textColor = .gray
        $0.textAlignment = .left
    }
    
    var adBlockLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24.0)
        $0.text = "3"
        $0.textAlignment = .center
    }
    
    let brokenSiteTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12.0)
        $0.numberOfLines = 2
        $0.text = "If this site appears to be broken,\n try to turn of Osiris Armor"
        $0.textColor = .lightGray
        $0.textAlignment = .center
    }

    let faviconImageView = UIImageView().then {
        $0.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        $0.layer.cornerRadius = 4
        if #available(iOS 13.0, *) {
            $0.layer.cornerCurve = .continuous
        }
        $0.clipsToBounds = true
    }
    
//    let hostLabel = UILabel().then {
//        $0.font = .systemFont(ofSize: 25.0)
//    }
    
    let shieldsSwitch = ShieldsSwitch()
    
    private let braveShieldsLabel = UILabel().then {
        $0.text = Strings.Shields.statusTitle
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    let statusLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.text = Strings.Shields.statusValueUp.uppercased()
    }
    
    // Shields Up
    
    class BlockCountView: UIView, Themeable {
        let stackView = UIStackView().then {
            $0.spacing = 12
            $0.alignment = .center
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        let countLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 36)
            $0.text = "0"
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        private lazy var descriptionLabel = ViewLabel().then {
            $0.attributedText = {
                let string = NSMutableAttributedString(
                    string: Strings.Shields.blockedCountLabel,
                    attributes: [.font: UIFont.systemFont(ofSize: 13.0)]
                )
                let attachment = ViewTextAttachment(view: self.infoButton)
                string.append(NSAttributedString(attachment: attachment))
                return string
            }()
            $0.backgroundColor = .clear
            $0.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)
        }
        
        let infoButton = Button().then {
            $0.setImage(UIImage(imageLiteralResourceName: "shields-help"), for: .normal)
            $0.hitTestSlop = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.imageEdgeInsets = .zero
            $0.titleEdgeInsets = .zero
            $0.contentEdgeInsets = UIEdgeInsets(top: -2, left: 4, bottom: -3, right: 4)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            isAccessibilityElement = true
            accessibilityTraits.insert(.button)
            accessibilityHint = Strings.Shields.blockedInfoButtonAccessibilityLabel
            
            addSubview(stackView)
            stackView.addArrangedSubview(countLabel)
            stackView.addArrangedSubview(descriptionLabel)
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        override var accessibilityLabel: String? {
            get {
                [countLabel.accessibilityLabel, Strings.Shields.blockedCountLabel]
                    .compactMap { $0 }
                    .joined(separator: " ")
            }
            set { assertionFailure() } // swiftlint:disable:this unused_setter_value
        }
        
        override func accessibilityActivate() -> Bool {
            infoButton.sendActions(for: .touchUpInside)
            return true
        }
        
        @available(*, unavailable)
        required init(coder: NSCoder) {
            fatalError()
        }
        
        func applyTheme(_ theme: Theme) {
            countLabel.textColor = theme.isDark ? .white : .black
            descriptionLabel.textColor = theme.isDark ? UIColor.white : .black
            infoButton.tintColor = theme.isDark ?
                Colors.orange400 :
                Colors.orange500
        }
    }
    
    let blockCountView = BlockCountView()
    
    let footerLabel = UILabel().then {
        $0.text = Strings.Shields.siteBroken
        $0.font = .systemFont(ofSize: 13.0)
        $0.appearanceTextColor = UIColor(rgb: 0x868e96)
        $0.numberOfLines = 0
    }
    
    // Shields Down
    
    let shieldsDownStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 16
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let shieldsDownDisclaimerLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
        $0.text = Strings.Shields.shieldsDownDisclaimer
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let reportSiteButton = ActionButton(type: .system).then {
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.titleEdgeInsets = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
        $0.setTitle(Strings.Shields.reportABrokenSite, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(armorImageView)

        armorImageView.snp.remakeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.width.equalTo(170)
            make.height.equalTo(140)
            make.centerX.equalTo(self)
        }
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 16
            $0.alignment = .center
            $0.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }

        urlView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
        
        urlView.addSubview(hostTitleLabel)
        hostTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(-60)
            make.top.equalTo(0)
            make.height.equalTo(14)
        }
        
        urlView.addSubview(hostLabel)
        
        hostLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(-60)
            make.top.equalTo(hostTitleLabel.snp.bottom)
            make.height.equalTo(14)
        }
        
        urlView.addSubview(shieldsSwitch)
        
        shieldsSwitch.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.top.equalTo(0)
        }
        
        adsCountView.addSubview(adsBloclImageView)
        
        adsBloclImageView.snp.remakeConstraints { make in
            make.left.equalTo(adsCountView).offset(5)
            make.width.equalTo(30)
            make.height.equalTo(50)
            make.centerY.equalTo(adsCountView)
        }
        
        adsCountView.addSubview(adBlockLabel)
        
        adBlockLabel.snp.remakeConstraints { make in
            make.left.equalTo(adsBloclImageView.snp.right).offset(15)
            make.width.equalTo(20)
            make.height.equalTo(30)
            make.centerY.equalTo(adsCountView)
        }
        
        adsCountView.addSubview(adBlockTitleLabel)
        
        adBlockTitleLabel.snp.remakeConstraints { make in
            make.left.equalTo(adBlockLabel.snp.right).offset(15)
            make.right.equalTo(adsCountView.snp.right)
            make.height.equalTo(30)
            make.centerY.equalTo(adsCountView)
        }
        
        addSubview(brokenSiteTitleLabel)
        
        
        [shieldsDownDisclaimerLabel, reportSiteButton].forEach(shieldsDownStackView.addArrangedSubview)
        stackView.addStackViewItems(
            .view(armorImageView),
            .customSpace(20),
            .view(urlView),
            .customSpace(64),
            .view(adsCountView),
            .customSpace(32),
            .view(brokenSiteTitleLabel)
        )
//        stackView.addStackViewItems(
//            .view(armorImageView),
////            .view(UIStackView(arrangedSubviews: [faviconImageView, hostLabel]).then {
////                $0.spacing = 8
////                $0.alignment = .center
////                $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
////                $0.isLayoutMarginsRelativeArrangement = true
////            }),
//            .view(urlView),
////            .view(shieldsSwitch),
//            .view(UIStackView(arrangedSubviews: [braveShieldsLabel, statusLabel]).then {
//                $0.spacing = 4
//                $0.alignment = .center
//            }),
//            .customSpace(32),
//            .view(blockCountView),
//            .view(footerLabel),
//            .view(shieldsDownStackView)
//        )
//
//        urlView.snp.makeConstraints { make in
//            make.left.equalTo(20)
//            make.top.equalTo(10)
//            make.right.equalTo(-20)
//            make.height.equalTo(30)
//        }
    }
    
    //OSIRIS
    
    func setOn(_ on: Bool, animated: Bool) {
        if on {
            DispatchQueue.main.async {
                self.armorImageView.image = UIImage(named: "amor_active")
            }
        } else {
            DispatchQueue.main.async {
                self.armorImageView.image = UIImage(named: "armor_inactive")
                self.adBlockLabel.text = "0"
            }
        }
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func applyTheme(_ theme: Theme) {
        shieldsSwitch.offBackgroundColor = theme.isDark ?
            UIColor(rgb: 0x26262E) :
            UIColor(white: 0.9, alpha: 1.0)
        blockCountView.applyTheme(theme)
        braveShieldsLabel.textColor = theme.colors.tints.home
        statusLabel.textColor = theme.colors.tints.home
        hostLabel.textColor = theme.isDark ? .white : .black
        shieldsDownDisclaimerLabel.textColor = theme.colors.tints.home
        reportSiteButton.tintColor = theme.isDark ? Colors.grey200 : Colors.grey800
    }
}
