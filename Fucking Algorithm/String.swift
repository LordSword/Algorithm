//
//  String.swift
//  Test
//
//  Created by Sword on 2021/9/2.
//

import Cocoa

extension String {
    
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
}

//MARK: - 截取字符串
extension String {
    
    subscript (i:Int) -> String {
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
    
    subscript (index:Int , length:Int) -> String {
        get {
            let start = self.index(self.startIndex, offsetBy: index)
            let end = self.index(start, offsetBy: length)
            return String(self[start..<end])
        }
    }
    
    func substring(to:Int) -> String {
        return self[0..<to]
    }
    
    func substring(from:Int) -> String {
        return self[from..<self.count]
    }
}
