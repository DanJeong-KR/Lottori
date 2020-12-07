//
//  UIView+addFullSubview.swift
//  wizschool
//
//  Created by wizschool on 2019/11/12.
//  Copyright © 2019 wizschool. All rights reserved.
//

import UIKit

extension UIView {

    func addFullSubview(_ view: UIView, front: Bool = true) {
        if front {
            self.addSubview(view)
        } else {
            self.insertSubview(view, at: 0)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

    func setCornerRadius(radius: Int) {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }

    func roundView() {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }

    func setBorder(color: UIColor, borderWidth: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
}
