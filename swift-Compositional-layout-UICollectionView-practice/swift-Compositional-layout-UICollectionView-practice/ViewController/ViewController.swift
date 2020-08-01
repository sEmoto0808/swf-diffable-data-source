//
//  ViewController.swift
//  swift-Compositional-layout-UICollectionView-practice
//
//  Created by 江本匠 on 2020/07/26.
//  Copyright © 2020 S.Emoto. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var compositionalCollectionView: UICollectionView! {
        didSet {
            compositionalCollectionView.register(UINib(nibName: "LabelCell", bundle: nil),
                                                 forCellWithReuseIdentifier: "LabelCell")
            compositionalCollectionView.register(UINib(nibName: "HeaderFooterView", bundle: nil),
                                                 forSupplementaryViewOfKind: ViewController.sectionHeaderElementKind,
                                                 withReuseIdentifier: "HeaderFooterView")
            compositionalCollectionView.register(UINib(nibName: "HeaderFooterView", bundle: nil),
                                                 forSupplementaryViewOfKind: ViewController.sectionFooterElementKind,
                                                 withReuseIdentifier: "HeaderFooterView")
            compositionalCollectionView.register(UINib(nibName: "SectionBackgroundDecorationView", bundle: nil),
                                                 forSupplementaryViewOfKind: ViewController.sectionBackgroundDecorationElementKind,
                                                 withReuseIdentifier: "SectionBackgroundDecorationView")
            compositionalCollectionView.dataSource = self
        }
    }
    
    private let textLabels: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
    private var sectionCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // レイアウトを指定する
        sectionCount = 6
        compositionalCollectionView.collectionViewLayout = orthogonalScrollingLayout
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell",
                                                            for: indexPath) as? LabelCell
            else { return UICollectionViewCell() }
        
        cell.set(text: textLabels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == ViewController.sectionHeaderElementKind {
            guard let headerFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: ViewController.sectionHeaderElementKind,
                                                                                         withReuseIdentifier: "HeaderFooterView",
                                                                                         for: indexPath) as? HeaderFooterView else {
                fatalError("Could not find proper header")
            }
            headerFooterView.set(text: "Section Header: \(indexPath.section)")
            return headerFooterView
        } else if kind == ViewController.sectionFooterElementKind {
            guard let headerFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: ViewController.sectionFooterElementKind,
                                                                                         withReuseIdentifier: "HeaderFooterView",
                                                                                         for: indexPath) as? HeaderFooterView else {
                fatalError("Could not find proper footer")
            }
            headerFooterView.set(text: "Section Footer: \(indexPath.section)")
            return headerFooterView
        }

        return UICollectionReusableView()
    }
}

// MARK: - Layout Pattern

extension ViewController {
    
    // MARK: - １列のリスト
    private var listSingleColumnLayout: UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - ２列のリスト
    private var listDoubleColumnLayout: UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)  // 列間の余白
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing  // 行間の余白
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                        leading: spacing,
                                                        bottom: spacing,
                                                        trailing: spacing)  // セクションの外側の余白
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Grid（横５分割）
    private var gridLayout: UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),    // アス比1:1
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let spacing = CGFloat(5)
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                     leading: spacing,
                                                     bottom: spacing,
                                                     trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))  // アス比1:1
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                        leading: spacing,
                                                        bottom: spacing,
                                                        trailing: spacing)  // セクションの内側の余白
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - セクション毎にレイアウトを変える（セクション数 = 3）
    private var distinctSectionLayout: UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }
            let columns = sectionLayoutKind.columnCount
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let itemSpacing = CGFloat(5)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing,
                                                         leading: itemSpacing,
                                                         bottom: itemSpacing,
                                                         trailing: itemSpacing)
            
            let groupHeight = columns == 1 ?
                NSCollectionLayoutDimension.absolute(44) :
                NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            let sectionSpacing = CGFloat(20)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: sectionSpacing,
                                                            leading: sectionSpacing,
                                                            bottom: sectionSpacing,
                                                            trailing: sectionSpacing)
            return section
        }
    }
    
    // MARK: - ヘッダーとフッターあり（セクション数 = 3）
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    static let sectionFooterElementKind = "section-footer-element-kind"
    
    private var withHeaderFooterSectionLayout: UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let spacing = CGFloat(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing / 2  // 行間の余白
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: spacing,
                                                        bottom: 0,
                                                        trailing: spacing)  // セクションの内側の余白
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(44))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: ViewController.sectionHeaderElementKind,
                                                                        alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: ViewController.sectionFooterElementKind,
                                                                        alignment: .bottom)
        sectionHeader.pinToVisibleBounds = true  // スクロールした時にヘッダーを上部に固定するかどうか
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - セクション毎にデコレーション
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    
    private var decoratedSectionLayout: UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let spacing = CGFloat(20)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing / 2  // 行間の余白
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                        leading: spacing,
                                                        bottom: spacing,
                                                        trailing: spacing)  // セクションの内側の余白
        
        // NSCollectionLayoutDecorationItem を UICollectionViewCompositionalLayout に登録する
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: ViewController.sectionBackgroundDecorationElementKind)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: spacing / 2,
                                                                            leading: spacing / 2,
                                                                            bottom: spacing / 2,
                                                                            trailing: spacing / 2)
        section.decorationItems = [sectionBackgroundDecoration]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(SectionBackgroundDecorationView.self,
                        forDecorationViewOfKind: ViewController.sectionBackgroundDecorationElementKind)
        return layout
    }
    
    // MARK: - 1行の中に2つの異なるレイアウトを設定
    private var distinctInOneLineLayout: UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                   heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.3)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)
            
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.4)),
                subitems: [leadingItem, trailingGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        }
    }
    
    // MARK: - 横スクロール in 縦スクロール（すべてのセクションで共有のスクロール）
    private var orthogonalScrollingLayout: UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let spacing = CGFloat(10)
            
            let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                         heightDimension: .fractionalHeight(1.0))
            let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                                leading: spacing,
                                                                bottom: spacing,
                                                                trailing: spacing)

            let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .fractionalHeight(0.3))
            let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                                 leading: spacing,
                                                                 bottom: spacing,
                                                                 trailing: spacing)
            
            let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                           heightDimension: .fractionalHeight(1.0))
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize,
                                                                 subitem: trailingItem,
                                                                 count: 2)

            // スクロールの設定
            let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                                            heightDimension: .fractionalHeight(0.4))
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize,
                                                                    subitems: [leadingItem, trailingGroup])
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .continuous  // Point!!

            return section
        }
    }
    
    // MARK: - 横スクロール in 縦スクロール（セクション毎にスクロールを制御する）
    private var orthogonalScrollingCustomLayout: UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        return UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = OrthogonalSectionKind(rawValue: sectionIndex) else { fatalError("unknown section kind") }
            
            let spacing = CGFloat(10)
            
            let leadingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                         heightDimension: .fractionalHeight(1.0))
            let leadingItem = NSCollectionLayoutItem(layoutSize: leadingItemSize)
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                                leading: spacing,
                                                                bottom: spacing,
                                                                trailing: spacing)

            let trailingItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .fractionalHeight(0.3))
            let trailingItem = NSCollectionLayoutItem(layoutSize: trailingItemSize)
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                                 leading: spacing,
                                                                 bottom: spacing,
                                                                 trailing: spacing)
            
            let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                           heightDimension: .fractionalHeight(1.0))
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize,
                                                                 subitem: trailingItem,
                                                                 count: 2)

            // スクロールの設定
            let isOrthogonallyScroll = sectionKind.orthogonalScrollingBehavior() != .none
            let containerGroupFractionalWidth = isOrthogonallyScroll ? CGFloat(0.85) : CGFloat(1.0)
            let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(containerGroupFractionalWidth),
                                                            heightDimension: .fractionalHeight(0.4))
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize,
                                                                    subitems: [leadingItem, trailingGroup])
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = sectionKind.orthogonalScrollingBehavior()  // Point!!

            let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                            elementKind: ViewController.sectionHeaderElementKind,
                                                                            alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            return section

        },
                                                   configuration: config)
    }
}
