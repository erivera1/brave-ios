// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

class OsirisNewTabPageViewController: NewTabPageViewController {

    private let backgroundImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.image = UIImage(named: OsirisConstants.backGroundImage)
    }

}
