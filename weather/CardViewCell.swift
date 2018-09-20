//
//  CardViewCell.swift
//  weather
//
//  Created by Julius Btesh on 9/18/18.
//

import Foundation
import UIKit
import SnapKit


class CardViewCell: UICollectionViewCell {
    
    var weatherData: Weather!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureHighLabel: UILabel!
    @IBOutlet weak var temperatureLowLabel: UILabel!
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> CardViewCell {
        guard let cell: CardViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue CardViewCell ***")
        }
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //imageView.layer.cornerRadius = 14.0
        
        layer.cornerRadius = 14.0
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2.5)

        dateLabel.text = ""
        temperatureLowLabel.text = ""
        temperatureLowLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        temperatureHighLabel.text = ""
        temperatureHighLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        //icon.isHidden = true

//        card = CardHighlight(frame: CGRect(x: 0, y: 0, width: 0 , height: 0))
//
//        card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
//        card.hasParallax = true
//
////                let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
////                card.shouldPresent(cardContentVC, from: self, fullscreen: false)
//
//        self.addSubview(card)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        //card.frame = CGRect(x: 0, y: 0, width: self.frame.size.width , height: self.frame.size.height)
        dateLabel.snp.makeConstraints { (make) in
            make.leading.greaterThanOrEqualTo(self).offset(10)
            make.leading.lessThanOrEqualTo(self).offset(20)
            make.centerY.equalTo(self)
        }
        
        icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(64)
            make.left.lessThanOrEqualTo(dateLabel.snp_rightMargin).offset(40)
        }
        
        temperatureHighLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(-5)
            make.left.greaterThanOrEqualTo(icon).offset(20)
            make.right.greaterThanOrEqualTo(self).offset(-40)
        }
        
        temperatureLowLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(temperatureHighLabel)
            make.centerY.equalTo(temperatureHighLabel).offset(15)
        }
    }
    
    func setWeather(data: Weather) {
        weatherData = data
        
        icon.image = UIImage(named: weatherData.icon!)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        dateLabel.text = String(describing: formatter.string(from: weatherData.time!))
            //.localizedString(from: weatherData.time!, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none))
        
        temperatureHighLabel.text = String(describing: weatherData.temperatureHigh) + "°"
        temperatureLowLabel.text = String(describing: weatherData.temperatureLow) + "°"
    }
}
