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

// leecode 292. Nim 游戏
// 你和你的朋友，两个人一起玩 Nim 游戏：
// 桌子上有一堆石头。
// 你们轮流进行自己的回合，你作为先手。
// 每一回合，轮到的人拿掉 1 - 3 块石头。
// 拿掉最后一块石头的人就是获胜者。
// 假设你们每一步都是最优解。请编写一个函数，来判断你是否可以在给定石头数量为 n 的情况下赢得游戏。如果可以赢，返回 true；否则，返回 false 。
func canWinNim(_ n: Int) -> Bool {
    return 0 != n%4
}
