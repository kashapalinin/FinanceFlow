//
//  TransactionsDelegate.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 01.01.2026.
//
import UIKit
import Domain

final class TransactionsDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    weak var dataSource: TransactionsDataSource?
    var onCategoryTapped: ((TransactionsByCategory?) -> Void)?
    
    init(dataSource: TransactionsDataSource? = nil) {
        self.dataSource = dataSource
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCategoryTapped?(dataSource?.getTransaction(at: indexPath.row))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 72)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 100, right: 16)
    }
}
