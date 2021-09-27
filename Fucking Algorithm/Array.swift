//
//  Array.swift
//  Test
//
//  Created by Sword on 2021/9/8.
//

import Cocoa

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
    
    // leecode 983. 最低票价
    // 在一个火车旅行很受欢迎的国度，你提前一年计划了一些火车旅行。在接下来的一年里，你要旅行的日子将以一个名为 days 的数组给出。每一项是一个从 1 到 365 的整数。
    // 火车票有三种不同的销售方式：
    // 一张为期一天的通行证售价为 costs[0] 美元；
    // 一张为期七天的通行证售价为 costs[1] 美元；
    // 一张为期三十天的通行证售价为 costs[2] 美元。
    // 通行证允许数天无限制的旅行。 例如，如果我们在第 2 天获得一张为期 7 天的通行证，那么我们可以连着旅行 7 天：第 2 天、第 3 天、第 4 天、第 5 天、第 6 天、第 7 天和第 8 天。
    // 返回你想要完成在给定的列表 days 中列出的每一天的旅行所需要的最低消费。
    func mincostTickets(_ days: [Int], _ costs: [Int]) -> Int {
        
        // dp思想
        var dp = Array<Int>(repeating:0, count: 365 + 31)
        
        for i in (0...365).reversed() {
            
            if (days.contains(i)) {
                dp[i] = Swift.min(dp[i + 1] + costs[0], Swift.min(dp[i + 7] + costs[1], dp[i + 30] + costs[2]))
            } else {
                // 还可以直接跳过直接到下一个出行日计算
                dp[i] = dp[i + 1]
            }
        }
        
        return dp[days[1]]
    }
    
    // leecode 162. 寻找峰值
    // 峰值元素是指其值严格大于左右相邻值的元素。
    // 给你一个整数数组 nums，找到峰值元素并返回其索引。数组可能包含多个峰值，在这种情况下，返回 任何一个峰值 所在位置即可。
    // 你可以假设 nums[-1] = nums[n] = -∞ 。
    // 你必须实现时间复杂度为 O(log n) 的算法来解决此问题
    func findPeakElement(_ nums: [Int]) -> Int {
        
        if nums.count < 2 {
            return 0
        }
        
        return maxNumIndexInArray(nums, nums.count/2, 0, nums.count - 1)
    }
    
    func maxNumIndexInArray(_ nums: [Int], _ center: Int, _ left: Int, _ right: Int) -> Int {
        
        if nums[left] > nums[left + 1] {
            return left
        } else if nums[right] > nums[right - 1] {
            return right
        }
        
        if nums[center] > nums[center - 1], nums[center] > nums[center + 1] {
            return center
        } else {
            
            if nums[center - 1] > nums[center] {
                
                return maxNumIndexInArray(nums, (left + center - 1)/2, left, center - 1)
            } else {
                return maxNumIndexInArray(nums, (center + right)/2, center, right)
            }
        }
    }
    
    // leecode 1048. 最长字符串链
    // 给出一个单词列表，其中每个单词都由小写英文字母组成。
    // 如果我们可以在 word1 的任何地方添加一个字母使其变成 word2，那么我们认为 word1 是 word2 的前身。例如，"abc" 是 "abac" 的前身。
    // 词链是单词 [word_1, word_2, ..., word_k] 组成的序列，k >= 1，其中 word_1 是 word_2 的前身，word_2 是 word_3 的前身，依此类推。
    // 从给定单词列表 words 中选择单词组成词链，返回词链的最长可能长度。
    func longestStrChain(_ words: [String]) -> Int {
        
        let arr = words.sorted { str1, str2 in
            return str1.count < str2.count
        }
        
        var dp = Dictionary<String, Int>()
        
        for str in arr {
            if 1 == str.count {
                dp[str] = 1
                continue
            }
            
            for i in 0..<str.count {
                
                var clipStr = ""
                if i > 0 {
                    clipStr.append(str.substring(to: i))
                }
                if i < str.count - 1 {
                    clipStr.append(str.substring(from: i + 1))
                }
                
                dp[str] = Swift.max( dp[str] ?? 0, (dp[clipStr] ?? 0) + 1)
            }
        }
        
        var res = 0
        for (_, value) in dp {
            res = Swift.max(res, value)
        }
        
        return res
    }
    
    // leecode 212. 单词搜索 II
    // 给定一个 m x n 二维字符网格 board 和一个单词（字符串）列表 words，找出所有同时在二维网格和字典中出现的单词。
    // 单词必须按照字母顺序，通过 相邻的单元格 内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。同一个单元格内的字母在一个单词中不允许被重复使用。
    // 字典树
    func findWords(_ board: [[String]], _ words: [String]) -> [String] {

        let head = findWordsTrie()
        
        // 生成字典树
        for word in words {
            var cur = head
            for char in word {
                
                if nil == cur.container[String(char)] {
                    cur.container[String(char)] = findWordsTrie()
                }
                cur = cur.container[String(char)]!
            }
            cur.word = word
        }
        
        var res = Set<String>()
        var tmpBoard = board
        
        for i in 0..<board.count {
            for j in 0..<board[0].count {
                findWordsDfs(&tmpBoard, head, &res, i, j)
            }
        }
        return Array<String>(res)
    }
    
    func findWordsDfs(_ board:inout [[String]],_ trie: findWordsTrie, _ res:inout Set<String>, _ i: Int, _ j: Int) {
        if i < 0 || i >= board.count || j < 0 || j >= board[0].count {
            return
        }
        
        // 正常思路，全部遍历
//        let char = board[i][j]
//
//        guard (nil != trie.container[char]) else {
//            return
//        }
//
//        if trie.container[char]!.word.count > 0 {
//            res.insert(trie.container[char]!.word)
//        }
//
//        board[i][j] = "-"
//        for (i, j) in [(i, j+1), (i, j-1), (i+1, j), (i-1, j)] {
//            findWordsDfs(&board, trie.container[char]!, &res, i, j)
//        }
//        board[i][j] = char
        
        // 优化 只遍历一边这个路径，因为路径上所有单词只需要一次就能拿到
        let char = board[i][j]
        let next = trie.container[char]

        if let word = next?.word, word.count > 0 {
            res.insert(word)
        }
        
        if let nxt = next, nxt.container.count > 0 {
            board[i][j] = "-"
            for (i, j) in [(i, j+1), (i, j-1), (i+1, j), (i-1, j)] {
                findWordsDfs(&board, nxt, &res, i, j)
            }
            board[i][j] = char
        }

        if 0 == next?.container.count {
            trie.container[char] = nil
        }
    }
    
    // leecode 36. 有效的数独
    // 请你判断一个 9x9 的数独是否有效。只需要 根据以下规则 ，验证已经填入的数字是否有效即可。
    // 数字 1-9 在每一行只能出现一次。
    // 数字 1-9 在每一列只能出现一次。
    // 数字 1-9 在每一个以粗实线分隔的 3x3 宫内只能出现一次。（请参考示例图）
    // 数独部分空格内已填入了数字，空白格用 '.' 表示。
    // 注意：
    // 一个有效的数独（部分已被填充）不一定是可解的。
    // 只需要根据以上规则，验证已经填入的数字是否有效即可。
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        
        var chars = [Character]()
        // 检查横向
        for arr in board {
            
            for char in arr {
                if !char.isWholeNumber {
                    continue
                }
                
                if chars.contains(char) {
                    return false
                }
                chars.append(char)
            }
            
            chars.removeAll()
        }
        
        // 检查竖向
        for i in 0..<9 {
            for j in 0..<9 {
                
                let char = board[j][i]
                if !char.isWholeNumber {
                    continue
                }
    
                if chars.contains(char) {
                    return false
                }
                
                chars.append(char)
            }
            chars.removeAll()
        }
        
        // 检查3*3单元格
        for (i, j) in [(0, 0), (0, 3), (0, 6), (3, 0), (3, 3), (3, 6), (6, 0), (6, 3), (6, 6)] {
            
            for h in 0..<3 {
                for v in 0..<3 {
                    
                    let char = board[h + i][v + j]
                    if !char.isWholeNumber {
                        continue
                    }
        
                    if chars.contains(char) {
                        return false
                    }
                    
                    chars.append(char)
                }
            }
            chars.removeAll()
        }
        
        return true
    }
    
    // lecode 718. 最长重复子数组
    // 给两个整数数组 A 和 B ，返回两个数组中公共的、长度最长的子数组的长度
    func findLength(_ nums1: [Int], _ nums2: [Int]) -> Int {
        
        return Swift.max(maxLength(nums1, nums2), maxLength(nums2, nums1))
    }
    func maxLength(_ nums1: [Int], _ nums2: [Int]) -> Int {
        var res = 0
        
        for i in 0..<nums1.count {
            
            var max = 0
            var k = 0
            for j in 0..<nums2.count {
                
                if i + j >= nums1.count {
                    break
                }
                
                if nums1[i + j] == nums2[j] {
                    k += 1
                } else {
                    k = 0
                }
                max = Swift.max(max, k)
            }
            
            res = Swift.max(res, max)
        }
        
        return res
    }
    
    // leecode 673. 最长递增子序列的个数
    // 给定一个未排序的整数数组，找到最长递增子序列的个数。
    func findNumberOfLIS(_ nums: [Int]) -> Int {
        
        var dp = [Int](repeating: 0, count: nums.count)
        var cnt = [Int](repeating: 0, count: nums.count)
        var res = 0
        var maxLength = 0
        
        for i in 0..<nums.count {
            dp[i] = 1
            cnt[i] = 1
            
            for j in 0..<i {
                
                if nums[i] > nums[j] {
                    
                    if dp[j] + 1 > dp[i] {
                        
                        dp[i] = dp[j] + 1
                        cnt[i] = cnt[j]
                    } else if dp[j] + 1 == dp[i] {
                        cnt[i] += cnt[j]
                    }
                }
            }
            
            if dp[i] > maxLength {
                maxLength = dp[i]
                res = cnt[i]
            } else if dp[i] == maxLength {
                res += cnt[i]
            }
        }

        return res
    }
    
    // leecode 1723. 完成所有工作的最短时间
    // 给你一个整数数组 jobs ，其中 jobs[i] 是完成第 i 项工作要花费的时间。
    // 请你将这些工作分配给 k 位工人。所有工作都应该分配给工人，且每项工作只能分配给一位工人。工人的 工作时间 是完成分配给他们的所有工作花费时间的总和。请你设计一套最佳的工作分配方案，使工人的 最大工作时间 得以 最小化 。
    // 返回分配方案中尽可能 最小 的 最大工作时间 。
    // 错误解法
    func minimumTimeRequired(_ jobs: [Int], _ k: Int) -> Int {
        
        let soredJobs = jobs.sorted { i, j in
            return i > j
        }
        
        let val = sumOfIntArray(jobs)/k
        let max = soredJobs.first!
        
        var dp = [[Int]]()
        for _ in 0..<k {
            dp.append([Int]())
        }
        
        for i in soredJobs {
            
            var minIndex = 0
            var minValue = sumOfIntArray(dp[0])
            for j in 0..<dp.count {
                
                let tmp = sumOfIntArray(dp[j])
                
                if 0 == tmp || tmp + i <= max || tmp + i <= val {
                    minIndex = j
                    break
                } else if minValue > tmp {
                    minValue = tmp
                    minIndex = j
                }
            }
            
            dp[minIndex].append(i)
        }
                
        var res = 0
        for i in dp {
            res = Swift.max(res, sumOfIntArray(i))
        }
        
        return res
    }
}

class findWordsTrie {
    
    var container = Dictionary<String, findWordsTrie>()
    var word = ""
}

extension Array {
    
    func sumOfIntArray(_ arr: [Int]) -> Int {
        var res = 0
        
        for i in arr {
            res += i
        }
        
        return res
    }
}
