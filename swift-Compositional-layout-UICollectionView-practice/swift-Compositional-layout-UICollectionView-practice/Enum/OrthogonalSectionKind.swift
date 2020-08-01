//
//  OrthogonalSectionKind.swift
//  swift-Compositional-layout-UICollectionView-practice
//
//  Created by 江本匠 on 2020/07/26.
//  Copyright © 2020 S.Emoto. All rights reserved.
//

import UIKit

enum OrthogonalSectionKind: Int, CaseIterable {
    case continuous, continuousGroupLeadingBoundary, paging, groupPaging, groupPagingCentered, none
    
    func orthogonalScrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .none:
            return UICollectionLayoutSectionOrthogonalScrollingBehavior.none
        case .continuous:
            return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuous
        case .continuousGroupLeadingBoundary:
            return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuousGroupLeadingBoundary
        case .paging:
            return UICollectionLayoutSectionOrthogonalScrollingBehavior.paging
        case .groupPaging:
            return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging
        case .groupPagingCentered:
            return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPagingCentered
        }
    }
}
