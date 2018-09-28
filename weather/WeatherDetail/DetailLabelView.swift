//
//  DetailLabelView.swift
//  weather
//
//  Created by Julius Btesh on 9/27/18.
//

import UIKit
import SnapKit

class DetailLabelView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        titleLabel.textColor = UIColor.darkGray
        descriptionLabel.textColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints({ (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.35)
        })
        
        descriptionLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel.snp_bottomMargin)
            make.left.right.equalTo(self)
            make.bottom.lessThanOrEqualTo(self)
            make.height.equalTo(self).multipliedBy(0.65)
        })
    }
}
