//
//  ViewController.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 02.08.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit

class MainController: UITabBarController {
    
    let nav1 = UINavigationController()
    let nav2 = UINavigationController()
    let nav3 = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupViews() {
        let first = ArchiveController(style: .plain, isIncome: false)
        first.title = "Ausgaben"
        nav1.viewControllers = [first]
        nav1.tabBarItem = UITabBarItem(title: "Ausgaben", image: UIImage?(#imageLiteral(resourceName: "expenses")), tag: 1)
        
        let second = ArchiveController(style: .plain, isIncome: true)
        second.title = "Einnahmen"
        nav2.viewControllers = [second]
        nav2.tabBarItem = UITabBarItem(title: "Einnahmen", image: UIImage?(#imageLiteral(resourceName: "income")), tag: 2)
        
        let third = ExportController(nibName: nil, bundle: nil)
        third.title = "Export"
        nav3.viewControllers = [third]
        nav3.tabBarItem = UITabBarItem(title: "Export", image: UIImage?(#imageLiteral(resourceName: "export")), tag: 3)
        
        self.viewControllers = [nav1, nav2, nav3]
    }
}

