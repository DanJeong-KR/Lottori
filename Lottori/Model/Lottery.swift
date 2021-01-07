//
//  Ball.swift
//  Lottori
//
//  Created by Sicc on 2020/12/13.
//  Copyright © 2020 DanJeong. All rights reserved.
//

import Foundation

struct Lottery: Codable {
  let returnValue: String
  let countNumber: Int?
  let countDate: String?
  let ballNumber1: Int?
  let ballNumber2: Int?
  let ballNumber3: Int?
  let ballNumber4: Int?
  let ballNumber5: Int?
  let ballNumber6: Int?
  let ballNumberBonus: Int?
  let totalSellAmount: Int?
  let firstWinAmount: Int?
  let firstWinCount: Int?
  
  
  enum CodingKeys: String, CodingKey {
    case returnValue
    case countNumber = "drwNo"
    case countDate = "drwNoDate"
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
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.returnValue = try values.decode(String.self, forKey: .returnValue)
    self.countNumber = try values.contains(.countNumber) ? values.decode(Int.self, forKey: .countNumber) : nil
    self.countDate = try values.contains(.countDate) ? values.decode(String.self, forKey: .countDate) : nil
    self.ballNumber1 = try values.contains(.ballNumber1) ? values.decode(Int.self, forKey: .ballNumber1) : nil
    self.ballNumber2 = try values.contains(.ballNumber1) ? values.decode(Int.self, forKey: .ballNumber2) : nil
    self.ballNumber3 = try values.contains(.ballNumber1) ? values.decode(Int.self, forKey: .ballNumber3) : nil
    self.ballNumber4 = try values.contains(.ballNumber1) ? values.decode(Int.self, forKey: .ballNumber4) : nil
    self.ballNumber5 = try values.contains(.ballNumber1) ? values.decode(Int.self, forKey: .ballNumber5) : nil
    self.ballNumber6 = try values.contains(.ballNumber1) ? values.decode(Int.self, forKey: .ballNumber6) : nil
    self.ballNumberBonus = try values.contains(.ballNumberBonus) ? values.decode(Int.self, forKey: .ballNumberBonus) : nil
    self.totalSellAmount = try values.contains(.totalSellAmount) ? values.decode(Int.self, forKey: .totalSellAmount) : nil
    self.firstWinAmount = try values.contains(.firstWinAmount) ? values.decode(Int.self, forKey: .firstWinAmount) : nil
    self.firstWinCount = try values.contains(.firstWinCount) ? values.decode(Int.self, forKey: .firstWinCount) : nil
    
  }
}

extension Lottery {
  var balls:[Int] {
    return [ballNumber1!, ballNumber2!, ballNumber3!, ballNumber4!, ballNumber5!, ballNumber6!]
  }
}
