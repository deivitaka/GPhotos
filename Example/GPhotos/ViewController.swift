//
//  ViewController.swift
//  GPhotos
//
//  Created by Deivi Taka on 08/20/2019.
//  Copyright (c) 2019 Deivi Taka. All rights reserved.
//

import UIKit
import GPhotos

class ViewController: UIViewController {
    
    @IBOutlet weak var actionB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActionButton()
    }
    
    @objc func actionButtonClicked() {
        actionB.isEnabled = false
        if GPhotos.isAuthorized {
            GPhotos.logout()
            self.actionB.isEnabled = true
            self.updateActionButton()
        } else {
            GPhotos.authorize() { (success, error) in
                self.updateActionButton()
                self.actionB.isEnabled = true
            }
        }
    }
}

private extension ViewController {
    
    func setupActionButton() {
        actionB.addTarget(self, action: #selector(actionButtonClicked), for: .touchUpInside)
        updateActionButton()
    }
    
    func updateActionButton() {
        if GPhotos.isAuthorized {
            actionB.setTitle("Logout", for: .normal)
            actionB.setTitleColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), for: .normal)
        } else {
            actionB.setTitle("Login", for: .normal)
            actionB.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
        }
    }
    
}
