//
//  AdvancedLayoutViewController.swift
//  swift-Compositional-layout-UICollectionView-practice
//
//  Created by 江本匠 on 2020/07/26.
//  Copyright © 2020 S.Emoto. All rights reserved.
//

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
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: advancedCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell",
                                                                for: indexPath) as? LabelCell
                else { return UICollectionViewCell() }
            cell.set(text: "\(list[indexPath.row])")
            return cell
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
