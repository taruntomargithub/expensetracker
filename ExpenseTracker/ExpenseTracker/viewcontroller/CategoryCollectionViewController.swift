//
//  CategoryCollectionViewController.swift
//  ExpenseTracker
//
//  Created by Tarun Tomar on 02/05/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    var observer: ((_ indexSet: Set<Int>) -> Void)?
    var dataArray: [String]! // Implecitly unwrapped as we pass this in segue
    var selectedCategoryIndexSet: Set<Int> = Set()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell : CategoryCell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        if cell.isCategorySelected {
            cell.isCategorySelected = false
            selectedCategoryIndexSet.remove(indexPath.row)
            cell.layer.borderColor = UIColor.gray.cgColor
        } else {
            cell.isCategorySelected = true
            selectedCategoryIndexSet.insert(indexPath.row)
            cell.layer.borderColor = UIColor.green.cgColor
        }
        
        if let observer = observer {
            observer(selectedCategoryIndexSet)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        
        // Configure the cell
        cell.title.text = dataArray[indexPath.row]
        cell.layer.cornerRadius = 17
        cell.layer.borderWidth = 3
        cell.layer.borderColor = selectedCategoryIndexSet.contains(indexPath.row) ? UIColor.green.cgColor : UIColor.gray.cgColor
        return cell
    }
}

class CategoryCell: UICollectionViewCell {
    @IBOutlet var title: UILabel!
    var isCategorySelected: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false

    }
}
