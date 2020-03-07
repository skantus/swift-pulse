//
//  HomeView.swift
//  Pulse
//
//  Created by Alejo Castaño on 02/03/2020.
//  Copyright © 2020 Alejo Castaño. All rights reserved.
//

import UIKit

extension HomeController {
    
    func signOutButton() -> UIButton {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: self.view!.bounds.width * 0.9, height: 50)
        button.backgroundColor = UIColor.systemGreen
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.center.x = view.center.x
        button.center.y = 500
        button.addTarget(self, action: #selector(onSignOutPress), for: .touchUpInside)
        return button
    }
    
}
