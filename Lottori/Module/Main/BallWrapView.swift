//
//  BallWrapView.swift
//  Lottori
//
//  Created by Sicc on 2020/12/15.
//  Copyright © 2020 DanJeong. All rights reserved.
//

import UIKit

class BallWrapView: UIView {
  
  private var currentBounds: CGRect!
  
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    currentBounds = self.bounds
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    guard currentBounds != self.bounds else { return }
    currentBounds = self.bounds
    self.subviews.forEach { (subview) in
      guard subview.bounds.height != 0 else { return }
      subview.roundView()
      logger(subview.bounds)
    }
  }
  
}
