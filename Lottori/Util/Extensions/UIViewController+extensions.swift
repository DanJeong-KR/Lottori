//
//  UIViewController+createModule.swift
//  wizschool
//
//  Created by wizschool on 2019/11/05.
//  Copyright © 2019 wizschool. All rights reserved.
//

import UIKit

extension UIViewController {

    static var nibName: String {
        return String(describing: Self.self)
    }

    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: nibName, bundle: Bundle.main)
    }

    static func createModule() -> UIViewController {
        let viewController = mainStoryboard.instantiateInitialViewController()
        if let view = viewController {
            return view
        }
        return UIViewController()
    }
}
