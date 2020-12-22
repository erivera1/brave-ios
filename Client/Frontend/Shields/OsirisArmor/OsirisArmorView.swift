// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

class OsirisArmorView: UIView, Themeable {

    var faviconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "amor_active")
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
    
    let stackView = UIStackView().then {
        $0.spacing = 12
        $0.alignment = .center
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    var toggle = UISwitch().then {
        $0.isEnabled = true
        $0.isOn = true
    }
    
    let buttonTest = UIButton().then {
        $0.backgroundColor = .green
        $0.setTitle("test", for: .normal)
    }
//        .then {
//        $0.title(for: .normal) = "test"
//    }
    
//    var isOn: Bool {
//        get { _isOn }
//        set { setOn(newValue, animated: false) }
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(faviconImageView)
        addSubview(buttonTest)
        
        buttonTest.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
        
        buttonTest.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        faviconImageView.snp.remakeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.width.equalTo(170)
            make.height.equalTo(140)
            make.centerX.equalTo(self)
        }
        
        addSubview(urlView)
        urlView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(faviconImageView.snp.bottom).offset(20)
            make.right.equalTo(-20)
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
        
//        urlView.isUserInteractionEnabled = true
       
        urlView.addSubview(toggle)

        toggle.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.top.equalTo(0)
        }

        urlView.bringSubviewToFront(toggle)
        
        addSubview(adsCountView)
        
        adsCountView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(urlView.snp.bottom).offset(20)
            make.right.equalTo(-20)
            make.height.equalTo(60)
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
        
        brokenSiteTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(adsCountView.snp.bottom).offset(20)
            make.right.equalTo(-30)
            make.height.equalTo(30)
        }
        
        self.backgroundColor = .yellow

    }
    
    @objc func buttonPressed() {
        print("hello test")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
