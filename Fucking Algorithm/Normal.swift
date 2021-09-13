//
//  Normal.swift
//  Test
//
//  Created by Sword on 2021/9/13.
//

import Foundation

// leecode 371 两整数之和，不使用 + - 符号
func sumOfTwoNum(_ a:Int, _ b:Int) -> Int {
    if 0 == b {
        return a
    }
    
    return sumOfTwoNum(a^b, (a&b)<<1)
}
