//
//  FavoriteView.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import UIKit

class FavoriteView: BaseViewXib {
    var favoriteListData: [FavoriteItem] = [] {
        didSet {
            favoriteCollectionView.reloadData()
        }
    }
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var myFavoriteTitle: UILabel!
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    override func setUpViews() {
        configCollectionView()
        moreLabel.font = .systemFont(ofSize: 16, weight: .regular)
        moreLabel.textColor = .cubeColorSystemGray7
        myFavoriteTitle.font = .systemFont(ofSize: 18, weight: .heavy)
        myFavoriteTitle.textColor = .cubeColorSystemGray5
    }
    
    private func configCollectionView() {
        favoriteCollectionView.registerCellNib(FavoriteItemCollectionViewCell.self)
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        favoriteCollectionView.backgroundColor = .clear
    }
}

extension FavoriteView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(FavoriteItemCollectionViewCell.self, indexPath: indexPath)
        cell.updateCell(favoriteItem: favoriteListData[indexPath.row])
        return cell
    }
}

extension FavoriteView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
