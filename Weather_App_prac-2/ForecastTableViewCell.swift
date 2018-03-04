//
//  ForecastTableViewCell.swift
//  Weather_App_prac-2
//
//  Created by 최동호 on 2018. 3. 2..
//  Copyright © 2018년 최동호. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    let rightTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.thin)
        label.text = "00"
        label.textColor = .white
        return label
    }()
//    right 10, centervertical -> rightTempLabel
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
        label.textColor = .white
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    
    func setupViews() {
        let margin = contentView.layoutMargins
        contentView.addSubview(self.rightTempLabel)
        self.rightTempLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.vertical)
        self.rightTempLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.horizontal)
        self.rightTempLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.vertical)
        self.rightTempLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.horizontal)
        self.rightTempLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin.top + 10).isActive = true
        self.rightTempLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -(margin.bottom + 10)).isActive = true
        self.rightTempLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -(margin.right)).isActive = true
        
        contentView.addSubview(self.statusLabel)
        self.statusLabel.rightAnchor.constraint(equalTo: self.rightTempLabel.leftAnchor, constant: -10).isActive = true
        self.statusLabel.centerYAnchor.constraint(equalTo: self.rightTempLabel.centerYAnchor).isActive = true
        
        contentView.addSubview(self.weatherImageView)
        self.weatherImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.weatherImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.weatherImageView.centerYAnchor.constraint(equalTo: self.statusLabel.centerYAnchor).isActive = true
        self.weatherImageView.rightAnchor.constraint(equalTo: self.rightTempLabel.leftAnchor, constant: -10).isActive = true
        
        contentView.addSubview(self.dateLabel)
        self.dateLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: margin.left).isActive = true
        self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: margin.top).isActive = true
        self.dateLabel.rightAnchor.constraint(greaterThanOrEqualTo: self.weatherImageView.leftAnchor, constant: -10).isActive = true
        
        contentView.addSubview(self.timeLabel)
        self.timeLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 5).isActive = true
        self.timeLabel.trailingAnchor.constraint(equalTo: self.dateLabel.trailingAnchor).isActive = true
        self.timeLabel.leadingAnchor.constraint(equalTo: self.dateLabel.leadingAnchor).isActive = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
