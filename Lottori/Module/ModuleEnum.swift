//
//  ModuleEnum.swift
//  wizschool
//
//  Created by wizschool on 2019/11/07.
//  Copyright © 2019 wizschool. All rights reserved.
//

import UIKit

enum Module {

    case Main
    case QRScanner


    var type: UIViewController.Type {
        switch self {
        case .Main:                 return MainViewController.self
        case .QRScanner:          return QRScannerViewController.self
        }
    }

    var vc: UIViewController {
        let vc = self.type.createModule()
        return vc
    }
}
