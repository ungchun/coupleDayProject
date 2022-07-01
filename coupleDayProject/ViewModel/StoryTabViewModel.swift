//
//  StoryTabViewModel.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/07/01.
//

import Foundation

class StoryTabViewModel {
    
    var onUpdatedLabels: () -> Void = {}
    
    var textA: String = "" {
        didSet {
            onUpdatedLabels()
        }
    }
    var textB: String = "" {
        didSet {
            onUpdatedLabels()
        }
    }
//    var textC: String = "" {
//        didSet {
//            onUpdatedLabels()
//        }
//    }
    
    func updateTest() {
        self.textA = CoupleTabViewModel.publicBeginCoupleDay
        self.textB = CoupleTabViewModel.publicBeginCoupleFormatterDay
    }
    
    init() {
        updateTest()
    }
}
