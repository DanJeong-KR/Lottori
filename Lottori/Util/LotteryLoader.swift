//
//  LotteryLoader.swift
//  Lottori
//
//  Created by Sicc on 2020/12/15.
//  Copyright © 2020 DanJeong. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

final class LotteryLoader {
  static let shared = LotteryLoader()
  var lotteries: [Lottery] = []
  
  let defaults = UserDefaults.standard
  var startUnitCount = 900
  let semaphore = DispatchSemaphore(value: 0)
  
  private init() {
    initLottery()
  }
  private func initLottery () {
    if let savedLottery = defaults.object(forKey: "lotteries") as? Data {
        let decoder = JSONDecoder()
        if let loadedLottery = try? decoder.decode([Lottery].self, from: savedLottery) {
          lotteries = loadedLottery
        }
    }
  }
  func load() {
    // 최신 데이터 있는지 체크
    if lotteries.count != 0 {
      logger(lotteries)
    }else {
      // 첫 입장일 경우
      DispatchQueue.global(qos: .userInitiated).async {
        let latestCountNumber = self.findLatestCountNumber()
        
      }
    }
  }
  
  func syncLottery() {
    let encoder = JSONEncoder()
    guard lotteries.count != 0 else {return}
    if let encoded = try? encoder.encode(lotteries) {
        defaults.set(encoded, forKey: "lotteries")
    }
  }
}

// MARK: - Private functions
extension LotteryLoader {
  private func findLatestCountNumber() -> Int {
      let (left, right) = self.findBSearchEdgeValues()
      if (self.filterCountNumber(left) == .answer) {
        return left
      }
      if (self.filterCountNumber(right) == .answer) {
        return right
      }
      return self.binarySearch(left: left, right: right)
  }
  
  private func findBSearchEdgeValues() -> (Int, Int) {
    var startCountNumber = startUnitCount
    var endCountNumber: Int!
      var whileCondition = false
      repeat {
        self.fetchLottery(inCountNumber: startCountNumber).done { (lottery) in
          whileCondition = lottery.returnValue == "success"
          if (lottery.returnValue == "success" || lottery.countNumber != nil) {
            startCountNumber += 10
          } else {
            endCountNumber = startCountNumber
            startCountNumber -= 10
          }
        }.ensure {
          self.semaphore.signal()
        }.catch { (error) in
          whileCondition = false
          print(error)
          // alert
        }
        self.semaphore.wait()
      } while (whileCondition)
    
    return (startCountNumber, endCountNumber)
    
  }
  private func binarySearch(left: Int, right: Int) -> Int {
    var left = left
    var right = right
    let mid = Int(floor(Double(left + right) / 2.0))
    
    switch filterCountNumber(mid) {
    case .left:
      right = mid
      return binarySearch(left: left, right: right)
    case .right:
      left = mid
      return binarySearch(left: left, right: right)
    case .answer:
      return mid
    }
  }
  private func filterCountNumber(_ countNumber: Int) -> BSearchAnswerKey {
    var isValidFirstBarrier = false
    awaitFetchLottery(in: countNumber) { (lottery) in
      isValidFirstBarrier = lottery.returnValue == "success"
    } catchBlock: {
      isValidFirstBarrier = false
    }
    
    var isValidSecondBarrier = false
    awaitFetchLottery(in: countNumber + 1) { (lottery) in
      isValidSecondBarrier = lottery.returnValue == "success"
    } catchBlock: {
      isValidSecondBarrier = false
    }
    
    if (isValidFirstBarrier) {
      if (isValidSecondBarrier) {
        return .right
      }
      return .answer
    } else {
      return .left
    }
  
    
    
  }
  
  private func awaitFetchLottery(in countNumber: Int, doneBlock: @escaping (Lottery) -> (), catchBlock: @escaping () -> ()) {
      self.fetchLottery(inCountNumber: countNumber).done { lottery in
        doneBlock(lottery)
      }.ensure {
        self.semaphore.signal()
      }.catch { error in
        print(error)
        catchBlock()
      }
      self.semaphore.wait()
    
  }
  
  private func fetchLottery(inCountNumber countNumber: Int) -> Promise<Lottery> {
    return Promise {
      seal in
        AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(countNumber)").validate().responseDecodable(of: Lottery.self) { (response) in
          switch response.result {
          case .success:
            guard let lottery = response.value else {
              return seal.reject(AFError.responseValidationFailed(reason: .dataFileNil)) }
            seal.fulfill(lottery)
          case let .failure(error):
            seal.reject(error)
          }
        }
    }
  }
}

enum BSearchAnswerKey {
  case answer
  case left
  case right
}
