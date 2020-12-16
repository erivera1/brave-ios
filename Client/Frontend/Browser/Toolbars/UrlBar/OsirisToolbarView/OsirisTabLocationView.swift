// Copyright 2020 The Brave Authors. All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Shared
import SnapKit
import XCGLogger
import BraveShared

//protocol OsirisTabLocationViewDelegate {
//    func tabLocationViewDidTapLocation(_ tabLocationView: OsirisTabLocationView)
//    func tabLocationViewDidLongPressLocation(_ tabLocationView: OsirisTabLocationView)
//    func tabLocationViewDidTapReaderMode(_ tabLocationView: OsirisTabLocationView)
//    func tabLocationViewDidBeginDragInteraction(_ tabLocationView: OsirisTabLocationView)
//    func tabLocationViewDidTapReload(_ tabLocationView: OsirisTabLocationView)
//    func tabLocationViewDidLongPressReload(_ tabLocationView: OsirisTabLocationView, from button: UIButton)
//    func tabLocationViewDidTapStop(_ tabLocationView: OsirisTabLocationView)
//    func tabLocationViewDidTapShieldsButton(_ urlBar: OsirisTabLocationView)
//    func tabLocationViewDidTapRewardsButton(_ urlBar: OsirisTabLocationView)
//    func tabLocationViewDidLongPressRewardsButton(_ urlBar: OsirisTabLocationView)
//    
//    /// - returns: whether the long-press was handled by the delegate; i.e. return `false` when the conditions for even starting handling long-press were not satisfied
//    @discardableResult func tabLocationViewDidLongPressReaderMode(_ tabLocationView: TabLocationView) -> Bool
//    func tabLocationViewLocationAccessibilityActions(_ tabLocationView: TabLocationView) -> [UIAccessibilityCustomAction]?
//}

class OsirisTabLocationView: TabLocationView {
    
//    var delegateOsiris: OsirisTabLocationViewDelegate?
    
    private struct TabLocationViewUX {
        static let hostFontColor = UIColor.black
        static let baseURLFontColor = UIColor.Photon.grey50
        static let spacing: CGFloat = 8
        static let statusIconSize: CGFloat = 18
        static let TPIconSize: CGFloat = 24
        static let buttonSize = CGSize(width: 44, height: 34.0)
        static let URLBarPadding = 4
    }
    
    fileprivate lazy var lockImageView: UIImageView = {
        let lockImageView = UIImageView(image: #imageLiteral(resourceName: "lock_verified").template)
        lockImageView.isHidden = true
        lockImageView.tintColor = #colorLiteral(red: 0.3764705882, green: 0.3843137255, blue: 0.4, alpha: 1)
        lockImageView.isAccessibilityElement = true
        lockImageView.contentMode = .center
        lockImageView.accessibilityLabel = Strings.tabToolbarLockImageAccessibilityLabel
        lockImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lockImageView
    }()

    fileprivate lazy var readerModeButton: ReaderModeButton = {
        let readerModeButton = ReaderModeButton(frame: .zero)
        readerModeButton.addTarget(self, action: #selector(tapReaderModeButton), for: .touchUpInside)
        readerModeButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressReaderModeButton)))
        readerModeButton.isAccessibilityElement = true
        readerModeButton.isHidden = true
        readerModeButton.imageView?.contentMode = .scaleAspectFit
        readerModeButton.contentHorizontalAlignment = .center
        readerModeButton.accessibilityLabel = Strings.tabToolbarReaderViewButtonAccessibilityLabel
        readerModeButton.accessibilityIdentifier = "TabLocationView.readerModeButton"
        readerModeButton.accessibilityCustomActions = [UIAccessibilityCustomAction(name: Strings.tabToolbarReaderViewButtonTitle, target: self, selector: #selector(readerModeCustomAction))]
        return readerModeButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for view in self.subviews {
            view.removeFromSuperview()
        }
        tabObservers = registerFor(.didChangeContentBlocking, .didGainFocus, queue: .main)

        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressLocation))
        longPressRecognizer.delegate = self

        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapLocation))
        tapRecognizer.delegate = self

        addGestureRecognizer(longPressRecognizer)
        addGestureRecognizer(tapRecognizer)

        let optionSubviews = [readerModeButton, reloadButton, separatorLine, shieldsButton]
        separatorLine.isUserInteractionEnabled = false

//        optionSubviews.append(rewardsButton)

        let buttonContentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        optionSubviews.forEach {
            ($0 as? CustomSeparatorView)?.layoutMargins = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            ($0 as? UIButton)?.contentEdgeInsets = buttonContentEdgeInsets
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        optionSubviews.forEach(tabOptionsStackView.addArrangedSubview)

        urlTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        urlTextField.isEnabled = true
        let subviews = [lockImageView, urlTextField, tabOptionsStackView]
        contentView = UIStackView(arrangedSubviews: subviews)
        contentView.distribution = .fill
        contentView.alignment = .center
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: TabLocationViewUX.spacing, bottom: 0, right: 0)
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.insetsLayoutMarginsFromSafeArea = false
        contentView.spacing = 10
        contentView.setCustomSpacing(5, after: urlTextField)
        tabOptionsStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        tabOptionsStackView.isLayoutMarginsRelativeArrangement = true
        addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self)
        }

        tabOptionsStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
        }
        // Setup UIDragInteraction to handle dragging the location
        // bar for dropping its URL into other apps.
        let dragInteraction = UIDragInteraction(delegate: self)
        dragInteraction.allowsSimultaneousRecognitionDuringLift = true
        self.addInteraction(dragInteraction)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class CustomSeparatorView: UIView {
    
    private let innerView: UIView
    init(lineSize: CGSize, cornerRadius: CGFloat = 0) {
        innerView = UIView(frame: .init(origin: .zero, size: lineSize))
        super.init(frame: .zero)
        backgroundColor = .clear
        innerView.layer.cornerRadius = cornerRadius
        addSubview(innerView)
        innerView.snp.makeConstraints {
            $0.width.height.equalTo(lineSize)
            $0.centerY.equalTo(self)
            $0.leading.trailing.equalTo(self.layoutMarginsGuide)
        }
    }
    
    override var backgroundColor: UIColor? {
        get {
            return innerView.backgroundColor
        }
        set {
            innerView.backgroundColor = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
