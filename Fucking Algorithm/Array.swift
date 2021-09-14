//
//  Array.swift
//  Test
//
//  Created by Sword on 2021/9/8.
//

import Foundation

extension Array {
    
    // leecode-2196
    // 含有重复元素集合的组合
    // 给定一个可能有重复数字的整数数组 candidates 和一个目标数 target ，找出 candidates 中所有可以使数字和为 target 的组合。
    // candidates 中的每个数字在每个组合中只能使用一次，解集不能包含重复的组合
    func combinationSum(_ list:[Int],_ target:Int) -> [[Int]] {
                
        var result = [[Int]]()
        var currList = [Int]()
        let candidates = list.sorted(by: { i, j in
            return i < j
        })
        
        backtracing(start: 0, list: candidates, currList: &currList, retList: &result, sum: 0, target: target)
        
        return result
    }
    // 回溯
    func backtracing( start:Int, list:[Int], currList:inout [Int], retList:inout [[Int]], sum:Int, target:Int) {
        
        if sum == target {
            retList.append(currList)
            return
        }
        
        if sum > target {
            return
        }
        
        for i in start..<list.count {
            // 去掉重复的数字，因为排序过，所以只需要跟前一个比较相同
            // i > start 同层不重复
            // i > 0 相对于上面就是多了(i == start) 所有的都不重复
            if i > start, list[i] == list[i - 1] {
                continue
            }
            currList.append(list[i])
            backtracing(start: i + 1, list: list, currList: &currList, retList: &retList, sum: sum + list[i], target: target)
            currList.removeLast()
        }
    }
    
    // leecode 1508 子数组和排序后的区间和
    // 给你一个数组 nums ，它包含 n 个正整数。你需要计算所有非空连续子数组的和，并将它们按升序排序，得到一个新的包含 n * (n + 1) / 2 个数字的数组。
    // 请你返回在新数组中下标为 left 到 right （下标从 1 开始）的所有数字和（包括左右端点）。由于答案可能很大，请你将它对 10^9 + 7 取模后返回。
    func rangeSum(_ nums: [Int], _ n: Int, _ left: Int, _ right: Int) -> Int {
        
        var arr = [Int]()
        
        for i in 0..<nums.count {
            var sum = 0
            
            for j in i..<nums.count {
                
                sum += nums[j]
                arr.append(sum)
            }
        }
        
        arr.sort { x, y in
            x < y
        }
        
        var result = 0
        for i in (left - 1)...(right - 1) {
            result += arr[i]
        }
        
        return result%(Int(1e9) + 7)
    }
    
    // leecode 1893 检查是否区域内所有整数都被覆盖
    // 给你一个二维整数数组 ranges 和两个整数 left 和 right 。每个 ranges[i] = [starti, endi] 表示一个从 starti 到 endi 的 闭区间
    // 如果闭区间 [left, right] 内每个整数都被 ranges 中 至少一个 区间覆盖，那么请你返回 true ，否则返回 false 。
    // 已知区间 ranges[i] = [starti, endi] ，如果整数 x 满足 starti <= x <= endi ，那么我们称整数x 被覆盖了。
    // 差分数组解法 (类似于位标记，但是位标记只能标记是否存在，差分可以标记存在并保存次数)
    func isCovered(_ ranges: [[Int]], _ left: Int, _ right: Int) -> Bool {
        
        // 标记开始位和结束位
        var diff = Array<Int>(repeating: 0, count:52)
        
        for i in 0..<ranges.count {
            diff[ranges[i][0]] += 1
            diff[ranges[i][1] + 1] -= 1
        }
        
        // 标记总和
        var sum = Array<Int>(repeating: 0, count:52)
        
        for i in 1..<diff.count {
            sum[i] = sum[i - 1] + diff[i]
        }
        
        for i in left...right {
            if sum[i] <= 0 {
                return false
            }
        }
        
        return true
    }
    
    // leecode 447 回旋镖的数量
    // 给定平面上 n 对 互不相同 的点 points ，其中 points[i] = [xi, yi] 。回旋镖 是由点 (i, j, k) 表示的元组 ，其中 i 和 j 之间的距离和 i 和 k 之间的距离相等（需要考虑元组的顺序）。
    // 返回平面上所有回旋镖的数量。
    func numberOfBoomerangs(_ points: [[Int]]) -> Int {
        var res = 0
        var dict = Dictionary<Int, Int>()
        for i in 0..<points.count {
            dict.removeAll()
            for j in 0..<points.count {
                if i == j {
                    continue
                }
                
                let dis = (points[j][0] - points[i][0])*(points[j][0] - points[i][0]) + (points[j][1] - points[i][1])*(points[j][1] - points[i][1])
                
                if let val = dict[dis] {
                    res += val
                } else {
                    dict[dis] = 0
                }
                dict[dis]? += 1
            }
        }
        
        return 2*res
    }
    
    // leecode 524. 通过删除字母匹配到字典里最长单词
    // 给你一个字符串 s 和一个字符串数组 dictionary 作为字典，找出并返回字典中最长的字符串，该字符串可以通过删除 s 中的某些字符得到。
    // 如果答案不止一个，返回长度最长且字典序最小的字符串。如果答案不存在，则返回空字符串。
    func findLongestWord(_ s: String, _ dictionary: [String]) -> String {
        
//        let array = dictionary.sorted { str1, str2 in
//
//            if str1.count == str2.count {
//
//                return str1.compare(str2) == .orderedAscending
//            }
//
//            return str1.count > str2.count
//        }
        var res = ""
        var pLength = 0
        var pIndex = 0
        for str in dictionary {
            
            if str.count > s.count {
                continue
            }
            
            let dValue = s.count - str.count
            
            for i in 0..<s.count {
                
                if str[pIndex] == s[i] {
                    
                    pIndex += 1
                    pLength += 1
                    if pLength == str.count {
                        
                        if res.count < str.count {
                            res = str
                        } else if res.count == str.count, res > str {
                            res = str
                        }
                        break
                    }
                }
                
                if (i - pIndex) > dValue {
                    break
                }
            }
            pLength = 0
            pIndex = 0
        }
        
        return res
    }
}
