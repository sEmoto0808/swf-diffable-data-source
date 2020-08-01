//
//  SectionHeaderView.swift
//  swift-Compositional-layout-UICollectionView-practice
//
//  Created by 江本匠 on 2020/07/26.
//  Copyright © 2020 S.Emoto. All rights reserved.
//

import UIKit

final class HeaderFooterView: UICollectionReusableView {

    @IBOutlet private weak var sectionHeaderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(text: String) {
        sectionHeaderLabel.text = text
    }
}
