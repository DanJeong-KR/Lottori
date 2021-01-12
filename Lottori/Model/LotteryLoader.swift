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
  private var unsafeLotteries: [LotteryData] = []
  private let defaults = UserDefaults.standard
  private var startBSearchUnitCount = 900
  private let semaphore = DispatchSemaphore(value: 0)
  private let downloadGroup = DispatchGroup()
  private var loaderLoadProgress: Float = 0
  
  private init() {
    initLottery()
  }
  private func initLottery () {
      if let savedLottery = defaults.object(forKey: "lotteryDatas") as? Data {
        getByDefault(data: savedLottery)
      }
  }
}
// MARK: - Interface
extension LotteryLoader {
  // Get
  var lotteries: [LotteryData] {
    return unsafeLotteries
  }
  
  var loadingProgress: Int {
    return Int((loaderLoadProgress * 100).rounded())
  }
  
  // Remove
  func removeAll() {
    DispatchQueue.main.async {
      self.defaults.removeObject(forKey: "lotteryDatas")
      self.unsafeLotteries = []
    }
  }
  
  func startLoader(completionHandler: (() -> ())? = nil) {
    DispatchQueue.global(qos: .userInitiated).async {
      print("startLoader - start",self.lotteries.count)
      if self.lotteries.count != 0 {
        guard let isLasted = self.checkDataIsLasted() else {
          // alert
          return
        }
        if (!isLasted) {
          let latestCountNumber = self.findLatestCountNumber()
          let lastCountNumber = self.unsafeLotteries.count
          self.loadLotteries(from: lastCountNumber + 1, to: latestCountNumber)
          self.saveToDefault()
        }
    } else {
        let latestCountNumber = self.findLatestCountNumber()
        self.loadLotteries(to: latestCountNumber)
        self.saveToDefault()
    }
      print("startLoader - end",self.lotteries.count)
      completionHandler?()
    }
  }
}

// MARK: - Lotteries Data Interface (accessing lotteries directly)
extension LotteryLoader {
  private func saveToDefault() {
    let encoder = JSONEncoder()
    guard unsafeLotteries.count != 0 else {return}
    if let encoded = try? encoder.encode(unsafeLotteries) {
        defaults.set(encoded, forKey: "lotteryDatas")
    }
  }
  
  private func getByDefault (data: Data) {
    let decoder = JSONDecoder()
    if let loadedLottery = try? decoder.decode([LotteryData].self, from: data) {
      unsafeLotteries = loadedLottery
    }
  }
  
  private func loadLotteries(from: Int = 1 ,to: Int) {
    var lotteries: [LotteryData] = []
    let iterationCount = to - from + 1
    DispatchQueue.concurrentPerform(iterations:iterationCount ) { index in
      downloadGroup.enter()
      self.fetchLottery(inCountNumber: from + index).done { lottery in
        lotteries.append(lottery)
        self.loaderLoadProgress += 1.0 / Float(iterationCount)
        print("loading progress", self.loadingProgress)
        self.downloadGroup.leave()
      }.catch { (error) in
        print(error)
        self.downloadGroup.leave()
      }
    }
    downloadGroup.notify(queue: DispatchQueue.main) {
      self.unsafeLotteries += lotteries
      self.semaphore.signal()
    }
    self.semaphore.wait()
  }
}

// MARK: - Finding Latest Count Number
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
    var startCountNumber = startBSearchUnitCount
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
  private func awaitFetchLottery(in countNumber: Int, doneBlock: @escaping (LotteryData) -> (), catchBlock:  @escaping () -> ()) {
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
}

// MARK: - Private Methods
extension LotteryLoader {
  private func fetchLottery(inCountNumber countNumber: Int) -> Promise<LotteryData> {
    return Promise {
      seal in
      AF.request(Constants.Url.Base + "\(countNumber)").validate().responseDecodable(of: LotteryData.self) { (response) in
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
  private func checkDataIsLasted() -> Bool? {
    var isLatest: Bool? = nil
    let lastCountNumber = unsafeLotteries.count
    awaitFetchLottery(in: lastCountNumber + 1, doneBlock: { lottery in
      isLatest = lottery.returnValue == "fail"
    }, catchBlock: {})
    return isLatest
  }
}



enum BSearchAnswerKey {
  case answer
  case left
  case right
}
