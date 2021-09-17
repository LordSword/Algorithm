//
//  LFUCache.swift
//  Test
//
//  Created by Sword on 2021/9/17.
//

import Foundation

class LFUCache {
    
    var cacheCapacity: Int
    var cacheCounts = [CacheKeyCount]()
    var cache = [Int: CacheKeyCount]()

    init(_ capacity: Int) {
        cacheCapacity = capacity
    }
    
    func get(_ key: Int) -> Int {
        
        if let res = cache[key] {
            
            res.count += 1
            let index = cacheCounts.firstIndex { value in
                return value.key == res.key
            }
            sortWithChangeValue(res, cacheCounts.distance(from: cacheCounts.startIndex, to: index!))
            
            return res.value
        } else {
            return -1
        }
    }
    
    func put(_ key: Int, _ value: Int) {
        guard cacheCapacity > 0 else {
            return
        }
        
        if let res = cache[key] {
            res.value = value
            res.count += 1
            let index = cacheCounts.firstIndex { value in
                return value.key == res.key
            }
            sortWithChangeValue(res, cacheCounts.distance(from: cacheCounts.startIndex, to: index!))
            
        } else {
            
            // 判断是否最大缓存
            // 如果已经到了最大缓存，删除掉最老的
            if cacheCapacity == cacheCounts.count {
                let tmp = cacheCounts.first!
                cache.removeValue(forKey: tmp.key)
                cacheCounts.removeFirst()
            }
            
            let new = CacheKeyCount(key, value, 1)
            cache[key] = new
            cacheCounts.insert(new, at: 0)
            sortWithChangeValue(new, 0)
        }
    }
    
    // 重新排序
    func sortWithChangeValue(_ change:CacheKeyCount, _ index:Int) {
        // 可优化的部分
        guard index + 1 < cacheCounts.count else {
            return
        }
        
        for i in (index + 1)..<cacheCounts.count {
            let tmp = cacheCounts[i]
            if tmp.count > change.count {
                break
            } else {
                // 跟前一个交换位置
                cacheCounts[i] = cacheCounts[i - 1]
                cacheCounts[i - 1] = tmp
            }
        }
    }
}

// 用于键值计数
class CacheKeyCount {
    var key:Int
    var value:Int
    var count:Int
    
    init(_ key1:Int, _ value1:Int, _ count1:Int) {
        key = key1
        value = value1
        count = count1
    }
}


