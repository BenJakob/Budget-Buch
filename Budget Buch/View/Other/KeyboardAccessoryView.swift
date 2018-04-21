//
//  KeyboardAccessoryView.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 14.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class KeyboardAccessoryView: UIView {

    var controllerDelegate: AddVCDelegate?
    
    let leftButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ArrowLeft"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let rightButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ArrowRight"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.addTarget(self, action: #selector(dissmissKeyboard), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    init(frame: CGRect, controllerDelegate: AddVCDelegate) {
        super.init(frame: frame)
        self.controllerDelegate = controllerDelegate
        setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .appThemeColor
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            rightButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            rightButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 4),
            rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            doneButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
            ])
    }
    
    // MARK: - Actions
    @objc private func dissmissKeyboard() {
        guard let delegate = controllerDelegate else { return }
        delegate.dismissKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
