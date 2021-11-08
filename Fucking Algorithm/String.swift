//
//  String.swift
//  Test
//
//  Created by Sword on 2021/9/2.
//

import Cocoa

extension String {
    
    // leecode 557. 反转字符串中的单词 III
    func reverseWords(_ s: String) -> String {
        
        var array = s.split(separator: " ")
        
        for i in 0..<array.count {
            
            let str = String(array[i])
            array[i] = Substring( str.reversed())
        }
        
        return array.joined(separator: " ")
    }
    
    // leecode 299. 猜数字游戏
    func getHint(_ secret: String, _ guess: String) -> String {
        // 第二种
        var a = 0, b = 0
        let ascii0 = Character("0").asciiValue!
        var nums = Array<Int>(repeating: 0, count: 10)
        
        for (c1, c2) in zip(secret, guess) {
            
            if c1 == c2 {
                a += 1
            } else {
                
                let i = Int(c1.asciiValue! - ascii0)
                let j = Int(c2.asciiValue! - ascii0)
                
                // 说明c1在前面guess出现过
                if nums[i] < 0 {
                    b += 1
                }
                // 说明c2在secret出现过
                if nums[j] > 0 {
                    b += 1
                }
                
                nums[i] += 1
                nums[j] -= 1
            }
        }
        
        
        // 第一种
//        var secrets = Array(secret)
//        var guesses = Array(guess)
//
//        var i = 0
//        var mapChar = [Int]()
//
//        while i < secrets.count, i < guesses.count {
//
//            if secrets[i] == guesses[i] {
//                mapChar.append(i)
//            }
//
//            i += 1
//        }
//
//        let a = mapChar.count
//
//        for i in mapChar.reversed() {
//
//            secrets.remove(at: i)
//            guesses.remove(at: i)
//        }
//
//        var b = 0
//
//        for char in guesses {
//
//            if secrets.contains(char) {
//                secrets.remove(at: secrets.firstIndex(of: char) ?? 0)
//                b += 1
//            }
//        }
//
//
        return "\(a)A\(b)B"
    }
    
    // leecode 187. 重复的DNA序列
    // 所有 DNA 都由一系列缩写为 'A'，'C'，'G' 和 'T' 的核苷酸组成，例如："ACGAATTCCG"。在研究 DNA 时，识别 DNA 中的重复序列有时会对研究非常有帮助。
    // 编写一个函数来找出所有目标子串，目标子串的长度为 10，且在 DNA 字符串 s 中出现次数超过一次。
    func findRepeatedDnaSequences(_ s: String) -> [String] {
        
        let arr = Array(s)
        var map = [String:Int]()
        
        for i in 0..<(arr.count - 10) {
            
            let s = String( arr[i..<(i + 10)])
            
            if let value = map[s] {
                
                map[s] = value + 1
            } else {
                map[s] = 1
            }
        }
        
        var result = [String]()
        
        for (key, value) in map {
            if value > 1 {
                result.append(key)
            }
        }
        
        return result
    }
    
    // 字符串中的最大回文字符串长度 (Manacher算法)
    func maxPalindromicSubstringLength() -> Int {
        
        guard self.count > 0 else {
            return 0
        }
        
        // 插入#字符，简化回文字符串中心问题
        var chars = String()
        for character in self {
            chars.append("#")
            chars.append(character)
        }
        chars.append("#")
                
        // 每个index的回文半径 （动态规划）
        var palindromicLengths = Array(repeating: 0, count: chars.count)
        // 当前回文中心点
        var center = -1
        // 当前回文右边界
        var range = -1
        // 最大的回文长度
        var maxPalindromicLength = 0
        
        for index in 0..<chars.count {
            
            // 如果当前位置超过了range
            if index > range {
                range = index
                center = index
                palindromicLengths[index] = 0
            } else if index > center {
                // 在中心点到有边界之间，认定为当前位置与中心点对应的左位置相同
                palindromicLengths[index] = palindromicLengths[2*center - index]
            }
            
            var leftRangeIndex = index - palindromicLengths[index] - 1
            var rightRangeIndex = index + palindromicLengths[index] + 1
            
            while leftRangeIndex >= 0, rightRangeIndex < chars.count, chars[leftRangeIndex] == chars[rightRangeIndex] {
                // 如果左边界和有边界的字符相等，将回文半径长度+1
                palindromicLengths[index] += 1
                // 更新下一次判断的回文边界
                leftRangeIndex -= 1
                rightRangeIndex += 1
            }
            
            if rightRangeIndex - 1 > range {
                range = rightRangeIndex - 1 // rightRangeIndex 有+1的
                center = (leftRangeIndex + rightRangeIndex)/2
            }
            
            maxPalindromicLength = max(maxPalindromicLength, palindromicLengths[index])
        }
        
        return maxPalindromicLength
    }
    
    // 是否是有效的回文字符串(如果可以删除一个字符串)
    func validPalindromicCanDeleteOneChar() -> Bool {
        
        var i = 0
        var j = self.count - 1
        
        while i < j {
            if self[i] != self[j] {
                return self.validPalindromic(i: i + 1, j: j) || self.validPalindromic(i: i, j: j - 1)
            }
            i += 1
            j -= 1
        }
        
        return true
    }
    
    func validPalindromic( i:Int, j:Int) -> Bool {
        
        var tmpI = i
        var tmpJ = j
        while tmpI < tmpJ {
            if self[tmpI] != self[tmpJ] {
                return false
            }
            tmpI += 1
            tmpJ -= 1
        }
        return true
    }
    
    // 两个相同字符之间的最大间距
    func maxLengthBetweenInSameChar() -> Int {
        
        var result = 0
        var cache = Dictionary<String, Int>()
        
//            for (i, c) in self.enumerated()
        for i in 0..<self.count {
            
//            let start = self.index(self.startIndex, offsetBy: i)
//            let end = self.index(start, offsetBy: 1)
//            let char = self[start..<end]
            
            
            let char = self[i]
            
            if let value = cache[char] {
                result = max(i - value - 1, result)
            } else {
                cache[char] = i
            }
        }
        
        return result
    }
    
    //leecode 58 最后一个单词的长度
    func lengthOfLastWord(_ s: String) -> Int {
        
        let arr = s.split(separator: " ")
        
        return arr.last?.count ?? 0

    }
    
    // leecode 583. 两个字符串的删除操作
    // 给定两个单词 word1 和 word2，找到使得 word1 和 word2 相同所需的最小步数，每步可以删除任意一个字符串中的一个字符。
    func minDistance(_ word1: String, _ word2: String) -> Int {
        
        var dp = [[Int]]()
        
        for i in 0...word1.count {
            
            for j in 0...word2.count {
                
                if 0 == j {
                    var arr = [Int]()
                    arr.append(i)
                    dp.append(arr)
                    continue
                }
                
                if 0 == i {
                    dp[0].append(j)
                    continue
                }
                
                let char1 = word1[i - 1]
                let char2 = word2[j - 1]
                
                if char1 == char2 {
                    dp[i].append(dp[i - 1][j - 1])
                } else {
                    dp[i].append(min(dp[i - 1][j], dp[i][j - 1]) + 1)
                }
            }
        }
        
        return dp[word1.count][word2.count]
    }
    
    // leecode 639. 解码方法 II
    func numDecodings(_ s: String) -> Int {
        
        var arr = [Character]()
        for i in s {
            arr.append(i)
        }
        
        if "0" == arr[0] {
            return 0
        }
        
        let mod:Int = Int(1e9 + 7)
        var dp = [Int](repeating: 0, count: s.count + 1)
        dp[0] = 1
        
        for i in 1...arr.count {
            dp[i] = (dp[i - 1] * check1Digit(arr[i - 1]))%mod
            
            if i > 1 {
                dp[i] = (dp[i] + dp[i - 2]*check2Digit(arr[i - 2], arr[i - 1]))%mod
            }
        }
        return dp[s.count]
    }
    func check1Digit(_ char: Character) -> Int {
        
        if "0" == char {
            return 0
        }
        
        return "*" == char ? 9:1
    }
    func check2Digit(_ char1: Character, _ char2: Character) -> Int {
        
        if "0" == char1 {
            return 0
        }
        
        if "*" == char1, "*" == char2 {
            return 15
        }
        
        if "*" == char1 {
            return char2 <= "6" ? 2:1
        }

        if "*" == char2 {
            
            if "1" == char1 {
                return 9
            }
            
            if "2" == char1 {
                return 6
            }
            return 0
        }
        
        return (("1" == char1) || ("2" == char1 && char2 <= "6")) ? 1:0
    }
}

//MARK: - 截取字符串
extension String {
    
    subscript (i: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: i)
        let end = self.index(start, offsetBy: 1)
        return String(self[start..<end])
    }
    
    subscript (r: Range<Int>) -> String {
        get {
            let start = self.index(self.startIndex, offsetBy: r.lowerBound)
            let end = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[start..<end])
        }
    }
    
    subscript (index: Int, length: Int) -> String {
        get {
            let start = self.index(self.startIndex, offsetBy: index)
            let end = self.index(start, offsetBy: length)
            return String(self[start..<end])
        }
    }
    
    func substring(to: Int) -> String {
        return self[0..<to]
    }
    
    func substring(from: Int) -> String {
        return self[from..<self.count]
    }
}
