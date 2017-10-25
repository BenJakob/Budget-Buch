//
//  AddCell.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 25.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AddCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var adView: GADBannerView = {
        let view = GADBannerView()
        view.adUnitID = "ca-app-pub-2120545226663778/1305328806"
        view.load(GADRequest())
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupViews() {
        addSubview(adView)
        
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: topAnchor),
            adView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
