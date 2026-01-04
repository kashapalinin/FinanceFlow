//
//  TransactionCollectionDataSource.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 03.01.2026.
//

import UIKit
import Domain

final class CategoryCollectionDataSource: NSObject, UICollectionViewDataSource {
    var categories: [TransactionCategory] = []
    var selectedCategory: TransactionCategory?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.item]
        let isSelected = category.id == selectedCategory?.id
        cell.configure(with: category, isSelected: isSelected)
        
        return cell
    }
}
