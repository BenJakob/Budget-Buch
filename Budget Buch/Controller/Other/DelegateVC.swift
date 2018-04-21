//
//  DelegateVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 02.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class DelegateVC: UINavigationController {

    var settingsDelegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let delegate = settingsDelegate else { return }
        delegate.deselectRow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
