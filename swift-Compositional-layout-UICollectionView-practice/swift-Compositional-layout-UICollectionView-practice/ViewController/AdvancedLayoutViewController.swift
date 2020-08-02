//
//  AdvancedLayoutViewController.swift
//  swift-Compositional-layout-UICollectionView-practice
//
//  Created by 江本匠 on 2020/07/26.
//  Copyright © 2020 S.Emoto. All rights reserved.
//

/// NOTE: 初期起動のstoryboardを変更する方法
///
/// https://www.366service.com/jp/qa/be25f04c990691d6ac92f00e978bd2ea

import UIKit

final class AdvancedLayoutViewController: UIViewController {

    @IBOutlet weak var advancedCollectionView: UICollectionView! {
        didSet {
            advancedCollectionView.register(UINib(nibName: "LabelCell", bundle: nil),
                                            forCellWithReuseIdentifier: "LabelCell")
            advancedCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    private enum Section {
        case main
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        advancedCollectionView.collectionViewLayout = distinctInOneLineLayout
    }
    

    private func configureDataSource() {
        
        // initial data
        let list = Array(0..<100)
        
        // NOTE: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
        // データを格納して管理するクラス
        //
        // SectionIdentifierType: Sectionを定義する型でHashableであること（Enumとかが多そう）
        // ItemIdentifierType: cellに表示するデータ型でHashableであること
        //
        // 用意されているメソッド
        //
        // データ管理系
        // ・データの追加・削除（SectionとItem）
        // ・並び替え（SectionとItem）
        // ・リロード（SectionとItem）
        //
        // データ参照系
        // ・データ数の取得（SectionとItem）
        // 　public var numberOfItems: Int { get }
        // 　public var numberOfSections: Int { get }
        // 　public func numberOfItems(inSection identifier: SectionIdentifierType) -> Int
        // ・値（一覧）の取得（SectionとItem）
        // 　public var sectionIdentifiers: [SectionIdentifierType] { get }
        // 　public var itemIdentifiers: [ItemIdentifierType] { get }
        // 　public func itemIdentifiers(inSection identifier: SectionIdentifierType) -> [ItemIdentifierType]
        // 　public func sectionIdentifier(containingItem identifier: ItemIdentifierType) -> SectionIdentifierType?
        // ・indexの取得（SectionとItem）
        // 　public func indexOfItem(_ identifier: ItemIdentifierType) -> Int?
        // 　public func indexOfSection(_ identifier: SectionIdentifierType) -> Int?
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        
        // NOTE: UICollectionViewDiffableDataSource
        // データをUIに紐付けて表示するクラス
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: advancedCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell",
                                                                for: indexPath) as? LabelCell
                else { return UICollectionViewCell() }
            cell.set(text: "\(identifier)")
            return cell
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension AdvancedLayoutViewController {
    
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
}
