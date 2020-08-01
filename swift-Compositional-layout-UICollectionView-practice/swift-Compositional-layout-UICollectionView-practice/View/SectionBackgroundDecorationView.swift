//
//  SectionBackgroundDecorationView.swift
//  swift-Compositional-layout-UICollectionView-practice
//
//  Created by 江本匠 on 2020/07/26.
//  Copyright © 2020 S.Emoto. All rights reserved.
//

import UIKit

final class SectionBackgroundDecorationView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure() {
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
}
