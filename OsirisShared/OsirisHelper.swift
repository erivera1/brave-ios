// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Data

class OsirisHelper {
    let sites = ["naver", "daum"]
    func sitesToDisableBlocking(url: URL) {
        let isPrivateBrowsing = PrivateBrowsingManager.shared.isPrivateBrowsing
        let domain = Domain.getOrCreate(forUrl: url, persistent: !isPrivateBrowsing)
        sites.forEach {
            if url.absoluteString.contains($0) {
                domain.shield_allOff = 1
            }
        }
    }
    
    func disableBlocking(url: URL) -> Bool {
        var result = false
        sites.forEach {
            if url.absoluteString.contains($0) {
                result = true
            }
        }
        return result
    }
}
