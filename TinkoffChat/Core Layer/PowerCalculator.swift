//
//  PowerCalculator.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 29.11.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IPowerCalculator {
    func makePow(value: Int, power: Int) -> Int
}

class PowerCalculator: IPowerCalculator {
    
    
    func makePow(value: Int, power: Int) -> Int {
        return Int(pow(Double(value), Double(power)))
    }
}
