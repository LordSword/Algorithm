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

// lecode 725. 分隔链表
// 给你一个头结点为 head 的单链表和一个整数 k ，请你设计一个算法将链表分隔为 k 个连续的部分。
// 每部分的长度应该尽可能的相等：任意两部分的长度差距不能超过 1 。这可能会导致有些部分为 null 。
// 这 k 个部分应该按照在链表中出现的顺序排列，并且排在前面的部分的长度应该大于或等于排在后面的长度。
// 返回一个由上述 k 部分组成的数组。
func splitListToParts(_ head: ListNode?, _ k: Int) -> [ListNode?] {
    
    var res = [ListNode?]()

    guard k > 0 else {
        return res
    }
    
    
    var node = head
    var count = 0
    
    while nil != node {
        count += 1
        node = node?.next
    }
    
    let i = count/k
    let j = count%k
    
    node = head
    for tmpI in 0..<k {
        
        res.append(node)
        var tmpCount = i + (tmpI < j ? 1:0);
        
        while nil != node, tmpCount > 0 {
            
            let tmpNode = node?.next
            if 1 == tmpCount {
                node?.next = nil
            }
            tmpCount -= 1
            node = tmpNode
        }
    }
    
    return res
}

// leecode 430. 扁平化多级双向链表
// 深度优先遍历
func flatten(_ head: FlattenNode?) -> FlattenNode? {
    
    flattenNode(head)
    return head
}
@discardableResult
func flattenNode(_ head: FlattenNode?) -> (head: FlattenNode?, tail: FlattenNode?) {
    
    var tmpHead = head
    var tail:FlattenNode?
    
    while nil != tmpHead {
        
        if nil != tmpHead?.child {
            let flatten = flattenNode(tmpHead?.child)
            tmpHead?.child = nil
            
            // 尾部交换
            flatten.tail?.next = tmpHead?.next
            tmpHead?.next?.prev = flatten.tail
            
            // 头部交换
            tmpHead?.next = flatten.head
            flatten.head?.prev = tmpHead
            
            tmpHead = flatten.tail
        }
        tail = tmpHead
        tmpHead = tmpHead?.next
    }
    
    return (head, tail)
}

// leecode 223. 矩形面积
// 给你 二维 平面上两个 由直线构成的 矩形，请你计算并返回两个矩形覆盖的总面积。
// 每个矩形由其 左下 顶点和 右上 顶点坐标表示：
// 第一个矩形由其左下顶点 (ax1, ay1) 和右上顶点 (ax2, ay2) 定义。
// 第二个矩形由其左下顶点 (bx1, by1) 和右上顶点 (bx2, by2) 定义。
func computeArea(_ ax1: Int, _ ay1: Int, _ ax2: Int, _ ay2: Int, _ bx1: Int, _ by1: Int, _ bx2: Int, _ by2: Int) -> Int {
    
    let aArea = (ax2 - ax1) * (ay2 - ay1)
    let bArea = (bx2 - bx1) * (by2 - by1)
    
    var x = 0
    let xDistance = bx1 - ax1
    if xDistance >= 0 {
        // b在a的右边
        x = min(bx2 - bx1, ax2 - ax1 - xDistance)
    } else {
        // b在a的左边
        x = min(ax2 - ax1, bx2 - bx1 + xDistance)
    }
    
    var y = 0
    let yDistance = by1 - ay1
    if yDistance >= 0 {
        y = min(by2 - by1, ay2 - ay1 - yDistance)
    } else {
        y = min(ay2 - ay1, by2 - by1 + yDistance )
    }
    
    var area = 0
    if x > 0, y > 0 {
        area = x * y
    }
    
    return bArea + aArea - area
}
