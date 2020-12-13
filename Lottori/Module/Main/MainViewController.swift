//
//  ViewController.swift
//  Lottori
//
//  Created by Sicc on 06/12/2020.
//  Copyright © 2020 DanJeong. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
  
  @IBOutlet weak var refreshButton: UIButton!
  
  @IBOutlet weak var ball1Label: UILabel!
  @IBOutlet weak var ball2Label: UILabel!
  @IBOutlet weak var ball3Label: UILabel!
  @IBOutlet weak var ball4Label: UILabel!
  @IBOutlet weak var ball5Label: UILabel!
  @IBOutlet weak var ball6Label: UILabel!
  lazy var ballLabels: [UILabel] = [ball1Label, ball2Label, ball3Label, ball4Label, ball5Label, ball6Label]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setStyle()
    fetchLatestBall()
  }
  
  func setStyle() {
    refreshButton.roundView()
  }
  
  func setBallNumber(lottery: Lottery) {
    ballLabels.enumerated().forEach { (index, lb) in
      lb.text = String(lottery.balls[index])
    }
    
  }
  
  @IBAction func onClickReset(_ sender: UIButton) {
  }
  
  @IBAction func onClickQRCode(_ sender: UIButton) {
    show(Module.QRScanner.vc, sender: nil)
  }
  
}

// MARK: - Network
extension MainViewController {
  func fetchLatestBall() {
    AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=903").validate().responseDecodable(of: Lottery.self) { (response) in
      guard let lottery = response.value else { return }
      self.setBallNumber(lottery: lottery)
    }
  }
}

