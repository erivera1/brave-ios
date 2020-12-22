// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

class OsirisArmorUrlView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let hostTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14.0)
        $0.text = "Armor Settings For :"
        $0.textColor = .green
    }
    
    let hostLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14.0)
        $0.text = "www.yehey.com"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView()
        addSubview(stackView)
        stackView.addStackViewItems(
            .view(UIStackView(arrangedSubviews: [hostTitleLabel, hostLabel]).then {
                $0.spacing = 8
                $0.alignment = .center
                $0.axis = .vertical
                $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
                $0.isLayoutMarginsRelativeArrangement = true
            })
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
