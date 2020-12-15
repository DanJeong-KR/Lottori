//
//  Ball.swift
//  Lottori
//
//  Created by Sicc on 2020/12/13.
//  Copyright © 2020 DanJeong. All rights reserved.
//

import Foundation

struct Lottery: Decodable {
  let returnValue: String
  let countNumber: Int
  let countData: String
  let ballNumber1: Int
  let ballNumber2: Int
  let ballNumber3: Int
  let ballNumber4: Int
  let ballNumber5: Int
  let ballNumber6: Int
  let ballNumberBonus: Int
  let totalSellAmount: Int
  let firstWinAmount: Int
  let firstWinCount: Int
  
  enum CodingKeys: String, CodingKey {
    case returnValue
    case countNumber = "drwNo"
    case countData = "drwNoDate"
    case ballNumber1 = "drwtNo1"
    case ballNumber2 = "drwtNo2"
    case ballNumber3 = "drwtNo3"
    case ballNumber4 = "drwtNo4"
    case ballNumber5 = "drwtNo5"
    case ballNumber6 = "drwtNo6"
    case ballNumberBonus = "bnusNo"
    case totalSellAmount = "totSellamnt"
    case firstWinAmount = "firstWinamnt"
    case firstWinCount = "firstPrzwnerCo"
    
    
  }
}

extension Lottery {
  var balls:[Int] {
    return [ballNumber1, ballNumber2, ballNumber3, ballNumber4, ballNumber5, ballNumber6]
  }
}
