//
//  main.swift
//  Test
//
//  Created by Sword on 2021/9/2.
//

import Foundation

//let palindromicString = "asdfggfdsajkjjkjoplsaasdfghjklkjhgfdsa"
//print(palindromicString.maxPalindromicSubstringLength())

//let str1 = "ababac"
//print(str1.validPalindromicCanDeleteOneChar())

//let str2 = "232sdhfksdhfjkdshfks"
//print("\(str2.maxLengthBetweenInSameChar()) sum-\(str2.count)")

//let arr1 = [1, 2, 4, 7, 10, 2, 1, 6, 1, 1]
//print(arr1.combinationSum(arr1, 6))

//let arr = ["ale","apple","monkey","plea"]
//let arr = ["abr","abc","monkey","plea"]
//print(arr.findLongestWord("abrc", arr))

//let arr = [4,3]
//print(arr.findPeakElement(arr))

//let arr = ["xbc","pcxbcf","xb","cxbc","pcxbc"]
//print(arr.longestStrChain(arr))

//let arr = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]]
//print(arr.findWords(arr, ["oath","pea","eat","rain"]))

//let arr = [[".",".",".",".","5",".",".","1","."],
//           [".","4",".","3",".",".",".",".","."],
//           [".",".",".",".",".","3",".",".","1"],
//           ["8",".",".",".",".",".",".","2","."],
//           [".",".","2",".","7",".",".",".","."],
//           [".","1","5",".",".",".",".",".","."],
//           [".",".",".",".",".","2",".",".","."],
//           [".","2",".","9",".",".",".",".","."],
//           [".",".","4",".",".",".",".",".","."]]
//print(arr.isValidSudoku(arr))

//let arr = [0,0,0,0,1]
//print(arr.findLength(arr, [1,0,0,0,0]))

//let arr = [1,3,5,4,7]
//print(arr.findNumberOfLIS(arr))

//let str = "test"
//print(str.minDistance("algorithm", "altruistic"))

//let arr =
//    [6518448,8819833,7991995,7454298,2087579,380625,4031400,2905811,4901241,8480231,7750692,3544254]
//print(arr.minimumTimeRequired(arr, 4))

//9 8 6 7 7 2 9 2
//9 1 10 8 6 4 8 6
var arr = [[9, 9], [8, 1], [6, 10], [7, 8], [7, 6], [2, 4], [9, 8], [2, 6]]

print(arr.minValue(arr))

var map: Dictionary<String, Any> = ["1": ["2": "3"]] {
    didSet {
        print("didChange")
    }
}

test(&map)

func test(_ map:inout Dictionary<String, Any>) {
    
    map["10"] = "11"
}
