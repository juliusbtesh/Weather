//
//  CardViewCell.swift
//  weather
//
//  Created by Julius Btesh on 9/18/18.
//

import Foundation
import Cards

class CardViewCell: UICollectionViewCell {
    var card: CardHighlight!
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> CardViewCell {
        guard let cell: CardViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue CardViewCell ***")
        }
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //imageView.layer.cornerRadius = 14.0

        card = CardHighlight(frame: CGRect(x: 0, y: 0, width: 0 , height: 0))

        card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
        card.icon = UIImage(named: "app-icon")
        card.title = "Welcome \nto \nCards !"
        card.itemTitle = "Flappy Bird"
        card.itemSubtitle = "Flap That !"
        card.textColor = UIColor.white
        
        card.hasParallax = true
        
//                let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
//                card.shouldPresent(cardContentVC, from: self, fullscreen: false)
        
        self.addSubview(card)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        card.frame = CGRect(x: 0, y: 0, width: self.frame.size.width , height: self.frame.size.height)
    }
}
