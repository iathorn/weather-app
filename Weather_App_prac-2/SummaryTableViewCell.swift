//
//  SummaryTableViewCell.swift
//  Weather_App_prac-2
//
//  Created by 최동호 on 2018. 3. 2..
//  Copyright © 2018년 최동호. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let weatherImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "SKY_A02"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let skyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.textColor = .white
        return label
    }()
    
    let minMaxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         label.textColor = .white
        return label
    }()
    
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 70, weight: UIFont.Weight.thin)
         label.textColor = .white
        return label
    }()
    
    func setupViews() {
        let margin = contentView.layoutMargins
        contentView.addSubview(self.weatherImageView)
        self.weatherImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin.top).isActive = true
        self.weatherImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: margin.left).isActive = true
        self.weatherImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.weatherImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        contentView.addSubview(self.skyNameLabel)
        self.skyNameLabel.topAnchor.constraint(equalTo: self.weatherImageView.topAnchor, constant: 0).isActive = true
        self.skyNameLabel.leftAnchor.constraint(equalTo: self.weatherImageView.rightAnchor, constant: 8).isActive = true
        self.skyNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -margin.right).isActive = true
        self.skyNameLabel.heightAnchor.constraint(equalTo: self.weatherImageView.heightAnchor).isActive = true

        
        contentView.addSubview(self.minMaxLabel)
        self.minMaxLabel.topAnchor.constraint(equalTo: self.weatherImageView.bottomAnchor, constant: 8).isActive = true
        self.minMaxLabel.leftAnchor.constraint(equalTo: self.weatherImageView.leftAnchor, constant: 0).isActive = true
        self.minMaxLabel.rightAnchor.constraint(equalTo: self.skyNameLabel.rightAnchor, constant: 0).isActive = true
        self.minMaxLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: Float(1000)), for: UILayoutConstraintAxis.vertical)
        
       
        contentView.addSubview(self.tempLabel)
        self.tempLabel.topAnchor.constraint(equalTo: self.minMaxLabel.bottomAnchor, constant: 8).isActive = true
        self.tempLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: margin.left).isActive = true
        self.tempLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -margin.bottom).isActive = true
        self.tempLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -margin.right).isActive = true

        
        

        
    }
    
    

}
