//
//  FirstViewController+UICollectionView.swift
//  weather
//
//  Created by Julius Btesh on 9/18/18.
//

import UIKit

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
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardViewCell = CardViewCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
        
//        let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
//        cardViewCell.card?.shouldPresent(cardContentVC, from: self, fullscreen: false)
        if allWeatherData.count > 0 {
            cardViewCell.setWeather(data: allWeatherData.object(at: indexPath.row) as! Weather)
        }

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "weatherDetails", sender: allWeatherData.object(at: indexPath.row))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "weatherDetails" ,
            let nextScene = segue.destination as? WeatherDetailViewController {
            let selectedWeatherData = sender as! Weather
            nextScene.weatherData = selectedWeatherData
//            nextScene.setupPage(data: selectedWeatherData)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width-40, height: view.bounds.height * 0.10)
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
