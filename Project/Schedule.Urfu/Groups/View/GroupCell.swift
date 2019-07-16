//
//  GroupCell.swift
//  Schedule.Urfu
//
//  Created by Sergey on 08/07/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    lazy var groupLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(groupLabel)
        groupLabel.anchorToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

