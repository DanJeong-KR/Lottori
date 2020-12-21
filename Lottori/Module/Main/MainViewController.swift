//
//  ViewController.swift
//  Lottori
//
//  Created by Sicc on 06/12/2020.
//  Copyright © 2020 DanJeong. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class MainViewController: UIViewController {
  
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var ballWrapView: UIView!
  
  private var ballLabels: [UILabel] = []
  private var ballViews: [UIView] = []
  private let ballNumber: Int = 8

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    fetchLatestBall()
    createBalls()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    addConstraintsInBalls()
  }
  
  func setInitStyle() {
    refreshButton.roundView()
  }
  
  private func createBalls() {
    Array(repeating: 1, count: ballNumber).enumerated().forEach { (index,_) in
      createBall()
    }
  }
  
  private func createBall() {
    createBallView(in: ballWrapView)
  }
  
  private func createBallView(in superView: UIView) {
    let ballView = UIView()
    superView.addSubview(ballView)
    ballView.backgroundColor = UIColor.black
    ballViews.append(ballView)
    createBallLabel(in: ballView)
  }
  
  private func createBallLabel(in superView: UIView) {
    let ballLabel = UILabel()
    superView.addSubview(ballLabel)
    ballLabels.append(ballLabel)
  }
  
  private func addConstraintsInBalls() {
    ballWrapView.snp.makeConstraints { (make) in
      make.height.equalTo(ballWrapView.bounds.width / 8).priority(1000)
    }
    
    for (index, (view, label)) in zip(ballViews, ballLabels).enumerated() {
      guard let superViewOfView = view.superview, let superViewOfLabel = label.superview else {
        return
      }
      
      view.snp.makeConstraints { (make) in
        make.leading.equalTo(index == 0 ? superViewOfView : ballViews[index - 1].snp.trailing)
        make.top.bottom.equalTo(superViewOfView)
        make.width.equalTo(superViewOfView.bounds.width / 8)
      }
      
      label.snp.makeConstraints { (make) in
        make.center.equalTo(superViewOfLabel)
      }
    }
  }
    
  
  private func setBallContents(lottery: Lottery) {
    for (index, ballNumber) in lottery.balls.enumerated() {
      ballLabels[index].text = String(ballNumber)
    }
    let lastBallIndex = ballLabels.count - 1
    ballLabels[lastBallIndex].text = String(lottery.ballNumberBonus!)
    ballLabels[lastBallIndex - 1].text = "+"
  }
  
  @IBAction func onClickReset(_ sender: UIButton) {
    UserDefaults.standard.removeObject(forKey: "lotteries")
    
  }
  
  @IBAction func onClickQRCode(_ sender: UIButton) {
    show(Module.QRScanner.vc, sender: nil)
  }
  
}

// MARK: - Network
extension MainViewController {
  func fetchLatestBall() {
    AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=903").validate().responseDecodable(of: Lottery.self) { (response) in
      switch response.result {
      case .success:
        guard let lottery = response.value else { return }
        self.setBallContents(lottery: lottery)
      case let .failure(error):
        logger(error)
      }
    }
  }
}

