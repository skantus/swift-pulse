//
//  HomeView.swift
//  Pulse
//
//  Created by Alejo Castaño on 02/03/2020.
//  Copyright © 2020 Alejo Castaño. All rights reserved.
//

import UIKit

extension HomeController {
    
    func title() -> UILabel {
       let title = UILabel()
       title.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
       title.center.x = view.center.x + 40
       title.center.y = view.center.y
       title.text = "Home Controller"
       return title
   }
    
}
