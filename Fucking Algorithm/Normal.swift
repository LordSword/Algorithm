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

// leecode 50 计算a的n次幂
func pow(_ a:Double, _ n:Int) -> Double {
    
//    return n > 0 ? pow1(a, n):1.0/pow1(a, -n)
    
    return n > 0 ? pow2(a, n):1.0/pow2(a, -n)
}

// 递归
func pow1(_ a:Double, _ n:Int) -> Double {
    if 0 == n {
        return 1
    }
    let b = pow1(a, n/2)
    return (0 == n%2) ? b*b:b*b*a;
}
// 迭代
func pow2(_ a:Double, _ n:Int) -> Double {
    
    var tmpN = n
    var tmpA = a
    var res = 1.0
    
    while tmpN > 0 {
        
        if 1 == tmpN%2 {
            res *= tmpA
        }
        tmpA *= tmpA
        
        tmpN /= 2
    }
    
    return res
}
