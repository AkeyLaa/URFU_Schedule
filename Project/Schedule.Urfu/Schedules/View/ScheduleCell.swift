//
//  ScheduleCell.swift
//  SecApp
//
//  Created by Sergey on 26/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame = frame
        return view
    }()
    
    lazy var lessonLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var teacherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
        return label
    }()
    
    lazy var lineSeparatorView: UIView = {
        let view = UIView()
        let color: UIColor = .gray
        view.backgroundColor = color
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var cabinetLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        containerView.addSubview(timeLabel)
        containerView.addSubview(lineSeparatorView)
        containerView.addSubview(lessonLabel)
        containerView.addSubview(teacherLabel)
        containerView.addSubview(cabinetLabel)
        addSubview(containerView)
        
        _ = containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 5, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        _ = timeLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 0)
        _ = lineSeparatorView.anchor(top: containerView.topAnchor, left: timeLabel.rightAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 5, leftConstant: 5, bottomConstant: 5, rightConstant: 0, widthConstant: 5, heightConstant: 0)
        _ = cabinetLabel.anchor(top: containerView.topAnchor, left: lineSeparatorView.rightAnchor, bottom: lessonLabel.topAnchor, right: containerView.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        _ = lessonLabel.anchor(top: cabinetLabel.bottomAnchor, left: lineSeparatorView.rightAnchor, bottom: teacherLabel.topAnchor, right: containerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 5, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        _ = teacherLabel.anchor(top: lessonLabel.bottomAnchor, left: lineSeparatorView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
