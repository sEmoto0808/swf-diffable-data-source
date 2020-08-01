//
//  SectionLayoutKind.swift
//  swift-Compositional-layout-UICollectionView-practice
//
//  Created by 江本匠 on 2020/07/26.
//  Copyright © 2020 S.Emoto. All rights reserved.
//

enum SectionLayoutKind: Int, CaseIterable {
    case list, grid5, grid3
    
    var columnCount: Int {
        switch self {
        case .grid3:
            return 3

        case .grid5:
            return 5

        case .list:
            return 1
        }
    }
}
