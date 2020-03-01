//
//  HomeController.swift
//  Pulse
//
//  Created by Alejo Castaño on 01/03/2020.
//  Copyright © 2020 Alejo Castaño. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    func setupViews() {
        view.backgroundColor = UIColor.white
        view.addSubview(title())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
