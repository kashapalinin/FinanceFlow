//
//  CategoryCollectionDelegate.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 03.01.2026.
//
import UIKit
import Domain

final class CategoryCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    private weak var vc: TransactionManageViewController?
    
    init(vc: TransactionManageViewController? = nil) {
        self.vc = vc
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = vc?.dataSource.categories[indexPath.item]
        vc?.dataSource.selectedCategory = category
        vc?.updateAddButtonState()
        collectionView.reloadData()
    }
}
