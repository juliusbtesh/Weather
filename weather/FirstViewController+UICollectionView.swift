//
//  FirstViewController+UICollectionView.swift
//  weather
//
//  Created by Julius Btesh on 9/18/18.
//

import UIKit
import Cards

extension FirstViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Configuration
    
    internal func configure(collectionView: UICollectionView) {
        collectionView.registerReusableCell(CardViewCell.self)
//        collectionView.registerReusableCell(CardHighlight.self)
//        collectionView.registerReusableCell(CardArticle.self)
//        collectionView.registerReusableCell(CardGroup.self)
//        collectionView.registerReusableCell(CardPlayer.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardViewCell = CardViewCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
        
        let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
        cardViewCell.card?.shouldPresent(cardContentVC, from: self, fullscreen: false)

        return cardViewCell
        
//        if indexPath.row == 0 {
//            return WorldPremiereCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
//        } else if indexPath.row == 1 {
//            return AppOfTheDayCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
//        } else if indexPath.row == 2 {
//            return FromTheEditorsCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
//        } else {
//            return GetStartedListCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
//        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return CGSize(width: collectionView.bounds.width, height: BaseRoundedCardCell.cellHeight)
//        } else {

            // Number of Items per Row
//            let numberOfItemsInRow = 1

            // Current Row Number
//            let rowNumber = indexPath.item/numberOfItemsInRow

            // Compressed With
            let compressedWidth = collectionView.bounds.width/3

            // Expanded Width
            let expandedWidth = (collectionView.bounds.width/3) * 2
//
//            // Is Even Row
//            let isEvenRow = rowNumber % 2 == 0
//
//            // Is First Item in Row
//            let isFirstItem = indexPath.item % numberOfItemsInRow != 0
//
//            // Calculate Width
//            var width: CGFloat = 0.0
//            if isEvenRow {
//                width = isFirstItem ? compressedWidth : expandedWidth
//            } else {
//                width = isFirstItem ? expandedWidth : compressedWidth
//            }

            return CGSize(width: compressedWidth, height: collectionView.bounds.height * 0.6)
//        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: TodaySectionHeader.viewHeight)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let sectionHeader = TodaySectionHeader.dequeue(fromCollectionView: collectionView, ofKind: kind, atIndexPath: indexPath)
//        sectionHeader.shouldShowProfileImageView = (indexPath.section == 0)
//        return sectionHeader
//    }
    
    // MARK: - UICollectionViewDelegate
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) {
//            presentStoryAnimationController.selectedCardFrame = cell.frame
//            dismissStoryAnimationController.selectedCardFrame = cell.frame
//            performSegue(withIdentifier: "presentStory", sender: self)
//        }
//    }
    
    
}
