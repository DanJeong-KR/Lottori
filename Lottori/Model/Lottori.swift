//
//  Lottori.swift
//  Lottori
//
//  Created by Sicc on 2021/01/07.
//  Copyright © 2021 DanJeong. All rights reserved.
//

import Foundation

protocol LottoriProtocol {
  associatedtype Ball: BallProtocol
  var selectedNumbers: Array<Ball> {get}
  var selectedBonusNumber: Ball? {get}
  var loadedLotteries: Array<LotteryData> {get}
  mutating func choose(ball: Ball, isBonus: Bool)
}

protocol BallProtocol {
  var isBonus: Bool { get }
  var isMatch: Bool {get}
  var number: Int {get}
  var color: String {get}
}

class Lottori: LottoriProtocol {
  var selectedBonusNumber: Ball? = nil
  var selectedNumbers: Array<Ball> = []
  var loadedLotteries: Array<LotteryData>
  
  func choose(ball: Ball, isBonus: Bool = false) {
    print("choose ", ball)
    if isBonus {
      self.selectedBonusNumber = ball
      return
    }
    if self.selectedNumbers.count < 6 {
      self.self.selectedNumbers.append(ball)
    }
  }
  
  init(loadedLotteries: Array<LotteryData>) {
    self.loadedLotteries = loadedLotteries
  }
  
}

struct Ball: BallProtocol {
  var isBonus: Bool
  var isMatch: Bool
  var number: Int
  var color: String
}



