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
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, SampleItemModel>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        advancedCollectionView.collectionViewLayout = distinctInOneLineLayout
    }
    

    private func configureDataSource() {
        
        // initial data
        let list = Array(0..<100).map { SampleItemModel(value: $0) }
        
        // NOTE: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
        // データを格納して管理するクラス
        //
        // SectionIdentifierType: Sectionを定義する型でHashableであること（Enumとかが多そう）
        // ItemIdentifierType: cellに表示するデータ型でHashableであること
        //
        // 用意されているメソッド、プロパティ
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, SampleItemModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        
        
        
        
        // NOTE: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
        // データをUIに紐付けて表示するクラス
        //
        // SectionIdentifierType: Sectionを定義する型でHashableであること（Enumとかが多そう）
        // ItemIdentifierType: cellに表示するデータ型でHashableであること
        //
        // Initializer
        // ・インスタンス生成
        // 　public typealias CellProvider = (UICollectionView, IndexPath, ItemIdentifierType) -> UICollectionViewCell?
        // 　public init(collectionView: UICollectionView, cellProvider: @escaping CellProvider)
        // ・ヘッダーとフッター追加
        // 　public typealias SupplementaryViewProvider = (UICollectionView, String, IndexPath) -> UICollectionReusableView?
        // 　public var supplementaryViewProvider: SupplementaryViewProvider?
        //
        // 用意されているメソッド、プロパティ
        //
        // データ管理系
        // ・データを適用する
        // 　open func apply(_ snapshot: NSDiffableDataSourceSnapshot, animatingDifferences: Bool = true, completion: (() -> Void)? = nil)
        //
        // データ参照系
        // ・Snapshotの取得
        // 　open func snapshot() -> NSDiffableDataSourceSnapshot
        // ・cellに表示するデータを取得
        // 　open func itemIdentifier(for indexPath: IndexPath) -> ItemIdentifierType?
        // ・indexPathの取得
        // 　open func indexPath(for itemIdentifier: ItemIdentifierType) -> IndexPath?
        //
        // 元のDataSourceにあって引き継がれた系
        // 　@objc open func numberOfSections(in collectionView: UICollectionView) -> Int
        // 　@objc open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        // 　@objc open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        // 　@objc open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
        // 　@objc open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool
        // 　@objc open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
        // 　@objc open func indexTitles(for collectionView: UICollectionView) -> [String]?
        // 　@objc open func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath
        dataSource = UICollectionViewDiffableDataSource<Section, SampleItemModel>(collectionView: advancedCollectionView) {
            // CellProvider
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SampleItemModel) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell",
                                                                for: indexPath) as? LabelCell
                else { return UICollectionViewCell() }
            cell.set(text: "\(identifier.value)")
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
