//
//  LoginCell.swift
//  SecApp
//
//  Created by Sergey on 25/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    weak var delegate: LoginControllerlDelegate?
    var loginButtonBottom: NSLayoutConstraint?
    
    let logoImageView: UIImageView = {
        let image = UIImage(named: "UrFULogo_U")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.layer.cornerRadius = 25
        button.backgroundColor = .purple
        button.isEnabled = false
        button.setTitle("Поехали", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    func setLoginButton() {
        loginButtonBottom?.constant = -100
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleLogin() {
        delegate?.finishLoggingIn()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loginButton.isEnabled = true
        addSubview(logoImageView)
        addSubview(loginButton)
        beginAnimation()
        loginButtonBottom = loginButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: -50, rightConstant: 16, widthConstant: 0, heightConstant: 50)[1]
        _ = logoImageView.anchor(top: centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -300, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 300, heightConstant: 350)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func beginAnimation () {
        UIView.animate(withDuration: 1.0, delay:0, options: [.repeat, .autoreverse], animations: {
            UIView.setAnimationRepeatCount(10)
            self.logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: {completion in
            self.logoImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

