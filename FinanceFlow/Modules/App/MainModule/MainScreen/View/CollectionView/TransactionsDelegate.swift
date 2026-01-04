//
//  TransactionsDelegate.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 01.01.2026.
//
import UIKit

final class TransactionsDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    weak var dataSource: TransactionsDataSource?
    
    init(dataSource: TransactionsDataSource? = nil) {
        self.dataSource = dataSource
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 72)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 100, right: 16)
    }
}
