//
//  Array.swift
//  Test
//
//  Created by Sword on 2021/9/8.
//

import Cocoa

extension Array {
    
    // 连续子数组的最大和
    func maxSumInArray(_ nums: [Int]) -> Int {
        // 贪心
        guard nums.count > 1 else {
            return 0
        }
        
        var res = nums[0]
        var sum = nums[0]
        
        for i in 1..<nums.count {
            sum = Swift.max(nums[i], nums[i] + sum)
            res = Swift.max(sum, res)
        }
        
        return res
                
        // DP - 动态规划
//        var dp = [Int](repeating: 0, count: nums.count)
//        dp[0] = nums[0]
//        var max = nums[0]
//        
//        for i in 1..<nums.count {
//            dp[i] = Swift.max(nums[i], nums[i] + dp[i - 1])
//            
//            max = Swift.max(dp[i], max)
//        }
//        
//        return max
    }
    
    // leecode 719. 找出第 K 小的数对距离
    func smallestDistancePair(_ nums: [Int], _ k: Int) -> Int {
        // 暴力
//        var distances = [Int]()
//        for i in 0..<nums.count - 1 {
//            for j in i + 1..<nums.count {
//
//                distances.append(abs(nums[i] - nums[j]))
//            }
//        }
//
//        distances.sort { $0 < $1 }
//
//        return distances[k - 1]
        
        // 二分 + 双指针
        let numbers = nums.sorted { $0 < $1 }
        
        var left = 0, right = numbers.last! - numbers.first!
        
        while left < right {
            let mid = (left + right)/2
            var count = 0
            
            var i = 0
            for j in 0..<numbers.count {
                while numbers[j] - numbers[i] > mid {
                    i = i + 1
                }
                count = count + j - i
            }
            
            if count >= k {
                right = mid - 1
            } else {
                left = mid + 1
            }
        }
        
        return left
    }
    
    // leecode 498. 对角线遍历
    func findDiagonalOrder(_ mat: [[Int]]) -> [Int] {
        
        var res = [Int]()
        var x = 0, y = 0
        
        let m = mat.first!.count, n = mat.count
        
        var moveUp = true
        
        while x < m, y < n {
            
            res.append(mat[y][x])
            if moveUp {
                // 往右上移动
                if (0 == y) || ( m - 1 == x) {
                    // 无法再往上移动, 尝试往右或者往下移动
                    if x == m - 1 {
                        // 下移动
                        y = y + 1
                    } else {
                        // 右移动
                        x = x + 1
                    }
                    moveUp = false
                } else {
                    // 往右上移动
                    x = x + 1
                    y = y - 1
                }
            } else {
                if (n - 1 == y) || (0 == x) {
                    // 无法再往左下移动，尝试往右或者下移动
                    if (n - 1 == y) {
                        // 右移动
                        x = x + 1
                    } else {
                        // 下移动
                        y = y + 1
                    }
                    moveUp = true
                } else {
                    // 往左下移动
                    x = x - 1
                    y = y + 1
                }
            }
        }
                
        return res
    }
    
    // leecode 475. 供暖器
    func findRadius(_ houses:inout [Int], _ heaters:inout [Int]) -> Int {
        // 找出所有房屋与供暖器的距离
        houses.sort{ i, j in  i < j }
        heaters.sort{ i, j in  i < j }
        
        heaters.insert(Int.min, at:0)
        heaters.append(Int.max)
        
        var cur = 0, res = 0
        for i in 0..<houses.count {
            
            while cur < heaters.count {
                if heaters[cur] >= houses[i] {
                    break
                }
                cur += 1
            }
            
            res = Swift.max(res, Swift.min(heaters[cur] - houses[i], houses[i] - heaters[cur - 1]))
        }
        return res
    }
    
    // leecode 1610. 可见点的最大数目
    func visiblePoints(_ points: [[Int]], _ angle: Int, _ location: [Int]) -> Int {
        // 算出所有点的角度关系
        // 根据角度排序
        // 然后取线段最集中的范围
        
        var relativeAngles = [Double]()
        var sameCount = 0
                
        for point in points {
            
            if point[0] == location[0], point[1] == location[1] {
                sameCount += 1
                continue
            }
            
            let angVal = atan2( Double(point[1] - location[1]), Double(point[0] - location[0])) * 180 / Double.pi
            
            relativeAngles.append(angVal < 0 ? (angVal + 360):angVal)
        }
        
        if 0 == relativeAngles.count {
            return sameCount
        }
        
        relativeAngles.sort { i, j in
            i < j
        }
        
        var res = 0
        var pre = 0
        var last = 1
        let val = Double(angle)
        
        while pre < relativeAngles.count, last - pre <  relativeAngles.count {
            
            let tmpI = last % relativeAngles.count
            let angVal = relativeAngles[tmpI] + (last >= relativeAngles.count ? 360:0)
            
            while pre < relativeAngles.count, angVal - relativeAngles[pre] > val {
                pre += 1
            }
            
//            if pre == relativeAngles.count {
//                pre -= 1
//            }
            last += 1

//            if (angVal - relativeAngles[pre] <= Double(angle)) {
                res = Swift.max(res, last - pre)
//            }
        }
        
        return res + sameCount
    }
    
    // leecode 506. 相对名次
    func findRelativeRanks(_ score: [Int]) -> [String] {
        
        var map = [Int:String]()
        let scoreBySorted = score.sorted {
            return $0 > $1
        }
        
        for (i, n) in scoreBySorted.enumerated() {
            switch i {
            case 0: map[n] = "Gold Medal"
            case 1: map[n] = "Silver Medal"
            case 2: map[n] = "Bronze Medal"
            default: map[n] = "\(i + 1)"
            }
        }
        
        return score.compactMap {
            map[$0]
        }

//        var scoreMap = zip(0..., score).map { $0 }
//
//        scoreMap.sort { i, j in
//            return i.1 > j.1
//        }
//
//        var realMap = [(Int, String)]()
//
//        for i in 0..<scoreMap.count {
//
//            let val = scoreMap[i]
//            let count = realMap.count + 1
//            switch count {
//            case 1:
//                realMap.append((val.0, "Gold Medal"))
//            case 2:
//                realMap.append((val.0, "Silver Medal"))
//            case 3:
//                realMap.append((val.0, "Bronze Medal"))
//            default:
//                realMap.append((val.0, String(count)))
//            }
//        }
//
//        realMap.sort { i, j in
//             return i.0 < j.0
//        }
//
//        return realMap.map { $0.1 }
    }
    
    // leecode 786. 第 K 个最小的素数分数
    func kthSmallestPrimeFraction(_ arr: [Int], _ k: Int) -> [Int] {
        
        var frac = [(Int, Int)]()
        
        for i in 0..<arr.count {
            for j in (i + 1)..<arr.count {
                frac.append((arr[i], arr[j]))
            }
        }
        
        frac.sort { f, s in
            return f.0*s.1 < f.1*s.0
        }
        
        return [frac[k - 1].0, frac[k - 1].1]
    }
    
    // leecode 563. 二叉树的坡度
    func findTilt(_ root: TreeNode?) -> Int {
        
        return calTreeTilt(root).1
    }
    
    func calTreeTilt(_ root: TreeNode?) -> (Int, Int) {
        
        guard let node = root else {
            return (0, 0)
        }
        
        let left = calTreeTilt(node.left)
        let right = calTreeTilt(node.right)
        
        return (node.val + left.0 + right.0, left.1 + right.1 + abs(left.0 - right.0))
    }
    
    /*
     // 小伟子胡诌题
     有一个对象，有两个属性 a，b。  都是正整数。
     N个这样的对象组成一个数组 x[]，让你找出来 三个对象 i,j,k
     要求这三个对象在数组是顺序排列，
     每个对象的 a 属性的值，是逐渐增加。 即 x[i].a <= x[j].a <= x[k].a
     求出，数字最小的 x[i].b + x[j].b + x[k].b
     数组中没有满足条件的 i,j,k 的时候，返回 -1
     输入：
     第一行是数组个数
     第二个是对象的 a 属性的值
     第二个是对象的 b 属性的值

     实例
     8
     9 8 6 7 7 2 9 2
     9 1 10 8 6 4 8 6
     */
    func minValue(_ nums:[[Int]]) -> Int {

        guard nums.count > 2 else {
            return -1
        }
        
        // 升序坐标数组
        var indexes = [[Int]]()

        for i in 0..<nums.count {

            let a = nums[i][0]
            
            var didAppend = false
            
            for j in 0..<indexes.count {
                
                if a < nums[indexes[j].last!][0] {
                    continue
                }
                
                if a == nums[indexes[j].last!][0] {
                    // 可优化替代当前序列(根据b值)
                    var copyArr = indexes[j]
                    copyArr.removeLast()
                    copyArr.append(i)
                    indexes.append(copyArr)
                } else {
                    indexes[j].append(i)
                    
                }
                
                didAppend = true
            }
            
            if !didAppend {
                indexes.append([i])
            }
        }
        
        var res:Int?
        // 可优化合并到升序计算
        for arr in indexes {
                        
            if arr.count < 3 {
                continue
            }
            
            // 找出三个最小的数字
            var min = Int.max, mid = Int.max, max = Int.max
            
            for i in arr {
                let b = nums[i][1]
                
                if b < min {
                    max = mid
                    mid = min
                    min = b
                } else if b < mid {
                    max = mid
                    mid = b
                } else if b < max {
                    max = b
                }
            }
            
            res = Swift.min(res ?? Int.max, min*mid*max)
        }

        return res ?? -1
    }
    
    // leecode 318. 最大单词长度乘积
    func maxProduct(_ words: [String]) -> Int {
    
        let charZero = Character("a").asciiValue!
        var mask = [Int](repeating: 0, count: words.count)
        
        for (index, str) in zip(0..., words) {
            
            for char in str {
                mask[index] |= 1 << (char.asciiValue! - charZero)
            }
        }
        
        var res = 0
        
        for i in 0..<mask.count {
            
            for j in (i + 1)..<mask.count {
                
                if 0 == mask[i] & mask[j] {
                    res = Swift.max(res, words[i].count * words[j].count)
                }
            }
        }
        
        return res
    }

    // leecode 542. 01矩阵
    func updateMatrix(_ mat: [[Int]]) -> [[Int]] {
        let dirs = [[-1,0], [1,0], [0, -1], [0, 1]]
        
        let m = mat.count, n = mat[0].count
        
        var res = [[Int]](repeating:[Int](repeating:0, count:n), count:m)
        var seen = res
        var quene = [(Int, Int)]()
        
        for i in 0..<m {
            for j in 0..<n {
                
                if 0 == mat[i][j] {
                    res[i][j] = 0
                    seen[i][j] = 1
                    
                    quene.append((i, j))
                }
            }
        }
        
        while (!quene.isEmpty)  {
        
            let (x, y) = quene.first!
            quene.removeFirst()
            
            for i in 0..<4 {
                
                let nx = dirs[i][0] + x
                let ny = dirs[i][1] + y
                
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && (0 == seen[nx][ny])) {
                    res[nx][ny] = res[x][y] + 1
                    seen[nx][ny] = 1
                    
                    quene.append((nx, ny))
                }
            }
        }
        
        return res
    }
    
    // leecode 1436. 旅行终点站
    func destCity(_ paths: [[String]]) -> String {
            var start = [String]()
            var end = [String]()
            
            for arr in paths {
                let s = arr.first!
                let e = arr.last!
                
                if start.contains(e) {
                    start.remove(at: start.firstIndex(of: e)!)
                } else {
                    end.append(e)
                }
                
                if end.contains(s){
                    end.remove(at: end.firstIndex(of: s)!)
                } else {
                    start.append(s)
                }
            }

            return end.last!
        }
    
    // leecode 189. 旋转数组
    // 给定一个数组，将数组中的元素向右移动 k 个位置，其中 k 是非负数。
    // O(1)
    // 环状代替，最优解法为数组翻转，然后分别翻转0..<k, k..<n-1
    func rotate(_ nums: inout [Int], _ k: Int) {
        
        let m = k%(nums.count)
        if 0 == m {
            return
        }
        
        var tmp = 0
        var start = 0
        var next = 0
        
        print(gcd(m, nums.count))
        
        for i in 0..<gcd(m, nums.count) {
            
            start = i
            tmp = nums[start]
            
            repeat {
                next = (start + m)%nums.count
                let tmpA = nums[next]
                nums[next] = tmp
                tmp = tmpA
                start = next
            } while i != next
        }
    }
    
    // leecode 517. 超级洗衣机
    // 假设有 n 台超级洗衣机放在同一排上。开始的时候，每台洗衣机内可能有一定量的衣服，也可能是空的。
    // 在每一步操作中，你可以选择任意 m (1 <= m <= n) 台洗衣机，与此同时将每台洗衣机的一件衣服送到相邻的一台洗衣机。
    // 给定一个整数数组 machines 代表从左至右每台洗衣机中的衣物数量，请给出能让所有洗衣机中剩下的衣物的数量相等的 最少的操作步数 。如果不能使每台洗衣机中衣物的数量相等，则返回 -1 。
    func findMinMoves(_ machines: [Int]) -> Int {
        
        var sum = 0
        for i in machines {
            sum += i
        }
        
        guard 0 == sum%machines.count else {
            return -1
        }
        
        let val = sum/machines.count
        var count = 0
        var res = 0
        
        for i in machines {
            // 加上平均值, 计算当前剩余值
            let num = (i - val)
            count += num
            
            res = Swift.max(res, num, abs(count))
        }

        return res
    }
    
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
    // leecode 300. 最长递增子序列
    func lengthOfLIS(_ nums: [Int]) -> Int {
        // 动态规划
//        var dp = [Int](repeating:1, count:nums.count)
//
//        for i in 1..<nums.count {
//
//            for j in 0..<i {
//
//                if nums[i] > nums[j] {
//                    dp[i] = Swift.max(dp[i], dp[j] + 1)
//                }
//            }
//        }
//
//        var res = 0
//
//        for i in dp {
//            res = Swift.max(res, i)
//        }
//
//        return res
        // 贪心二分
        var d = [Int](repeating: 0, count: nums.count + 1)
        var len = 1
        d[len] = nums[0]
        
        for i in 1..<nums.count {
            
            // 如果当前数字大于最后一个数，添加到后面
            if nums[i] > d[len] {
                len += 1
                d[len] = nums[i]
            } else {
                // 如果当前数字小于最后一个数字，将查找最小大雨num[i]的数字替换掉
                var l = 1
                var r = len
                var pos = 0
                
                while l < r {
                    let mid = (l + r)/2
                    
                    if d[mid] >= nums[i] {
                        r = mid - 1
                    } else {
                        l = mid + 1
                        pos = mid
                    }
                }
                
                d[1 + pos] = nums[i]
            }
        }
        
        return len
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
