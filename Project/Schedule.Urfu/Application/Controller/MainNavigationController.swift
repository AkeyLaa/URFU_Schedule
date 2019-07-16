//
//  MainNavigationController.swift
//  Schedule.Urfu
//
//  Created by Sergey on 02/07/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation

import UIKit

class MainNavigationController: UINavigationController, UINavigationBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "Apple", size: 30) ??
                UIFont.systemFont(ofSize: 30)]
        
        if UserDefaults.standard.isLoggedIn() {
            let schedulesController = SchedulesController()
            viewControllers = [schedulesController]
        } else {
            let locale = NSLocale.preferredLanguages.first ?? "en"
            UserDefaults.standard.setLanguage(value: locale)
            let groupsController = GroupsController()
            groupsController.downloadGroups(notification: NSNotification(name: Notification.Name(rawValue: "downloadGroups"), object: nil))
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    @objc func showLoginController() {
        let loginController = LoginController()
        self.present(loginController, animated: true, completion: {    })
    }
    
    
}
