//
//  ViewController.swift
//  Pulse
//
//  Created by Alejo Castaño on 01/03/2020.
//  Copyright © 2020 Alejo Castaño. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.setNeedsStatusBarAppearanceUpdate()
        try? VideoBackground.shared.play(view: view, videoName: "video-landing", videoType: "mp4")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc func navigateToSignInView() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInButton())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
