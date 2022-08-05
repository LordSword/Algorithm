//
//  Sort.swift
//  Test
//
//  Created by Sword on 2022/6/14.
//

import Foundation
import AppKit

class Sort {

    // 插入排序 - 直接插值排序
    // 思想：默认前面的已排序
    class func insertionSort(nums:inout [Int]) {
        
        for i in 1..<nums.count {
            
            var tmp = i
            while tmp > 0 {
                
                if nums[tmp] >= nums[tmp - 1] {
                    break
                }
                
                let num = nums[tmp]
                nums[tmp] = nums[tmp - 1]
                nums[tmp - 1] = num
                
                tmp = tmp - 1
            }
        }
    }
    
    // 希尔排序
    // 思想：步长
    class func shellSort(nums:inout [Int]) {
        
        var gap = nums.count/2
        while gap > 0 {
            for i in gap..<nums.count {
                let tmp = nums[i]
                var j = i
                
                while j >= gap, tmp < nums[j - gap] {
                    nums[j] = nums[j - gap]
                    j = j - gap
                }
                
                nums[j] = tmp
            }
            
            gap = gap/2
        }
    }
    
    // 冒泡排序 - 默认后面已排序
    class func bubbleSort(nums:inout [Int]) {
        
        for i in 0..<nums.count - 1 {
            for j in 0..<(nums.count - i - 1) {
                
                if nums[j] > nums[j + 1] {
                    
                    let tmp = nums[j]
                    nums[j] = nums[j + 1]
                    nums[j + 1] = tmp
                }
            }
        }
    }
    
    // 选择排序 - 优先排序前面
    class func selectionSort(nums:inout [Int]) {
        
        for i in 0..<nums.count {
            var minIndex = i
            for j in (i + 1)..<nums.count {
                if nums[minIndex] > nums[j] {
                    minIndex = j
                }
            }
            
            let tmp = nums[i]
            nums[i] = nums[minIndex]
            nums[minIndex] = tmp
        }
    }
    
    // 快速排序 - 分而治之
    class func quickSort(nums:inout [Int], start: Int, end: Int) {
        guard end > start else {
            return
        }
        
        var left = start
        var right = end
        let pivot = nums[left]
        
        while left < right {
            
            while left < right, nums[right] >= pivot {
                right -= 1
            }
            nums[left] = nums[right]
            
            while left < right, nums[left] <= pivot {
                left += 1
            }
            nums[right] = nums[left]
        }
        
        nums[left] = pivot
        
        quickSort(nums: &nums, start: start, end: left - 1)
        quickSort(nums: &nums, start: left + 1, end: end)
    }
    
    // 归并排序
    class func mergeSort(nums:[Int]) -> [Int] {
        guard nums.count > 1 else {
            return nums
        }
        
        if nums.count == 2 {
            
            return [min(nums[0], nums[1]), max(nums[0], nums[1])]
        } else {
            
            let mid = nums.count/2
            
            var leftArr = mergeSort(nums: Array(nums[0..<mid]))
            var rightArr = mergeSort(nums: Array(nums[mid..<nums.count]))
            
            var res = [Int]()
            while (!leftArr.isEmpty || !rightArr.isEmpty) {
                if leftArr.isEmpty {
                    res.append(rightArr.removeFirst())
                } else if rightArr.isEmpty {
                    res.append(leftArr.removeFirst())
                } else if rightArr.first! > leftArr.first! {
                    res.append(leftArr.removeFirst())
                } else {
                    res.append(rightArr.removeFirst())
                }
            }
            
            return res
        }
    }
    
    // 基数排序(不适用于负数?)
    class func radixSort(nums:[Int]) -> [Int] {
        guard nums.count > 1 else {
            return nums
        }
        // 取出最大值
        var max = nums.first!
        for i in 1..<nums.count {
            if nums[i] > max {
                max = nums[i]
            }
        }
        // 计算最大值的位数
        var count = 0
        while max > 0 {
            count += 1
            max /= 10
        }
        
        var pviot = 1
        var res = nums
        
        for _ in 0..<count {
            
            var tmpArr = [[Int]](repeating: [Int](), count: 10)
            
            for num in res {
                // 取出当前位基数
                let index = num/pviot%10
                tmpArr[index].append(num)
            }
            
            // 移除前基数排序数据
            res.removeAll()
            
            // 读取根据当前基数排序过的数组
            for arr in tmpArr {
                res.append(contentsOf: arr)
            }

            // 基数递增
            pviot *= 10
        }
        
        return res
    }
    
    // 堆排序, 完全二叉树
    // 父节点 (n + 1)/2 - 1
    // 左节点 n*2 + 1
    // 右节点 n*2 + 2
    class func heapSort(nums:inout [Int]) {
        // 大顶堆
        var k = nums.count - 1
        
        while k > 0 {
            
            var t: Int = (k + 1)/2 - 1
            while t >= 0 {
                
                // 最大节点index
                var leaf = 2*t + 1
                // 判断右节点
                let rLeaf = 2*t + 2
                // rLeaf <= k 为了防止范围溢出
                if rLeaf <= k, nums[rLeaf] > nums[leaf] {
                    // 如果右节点大于左节点，则将节点位置设为右节点
                    leaf = rLeaf
                }
                
                if nums[leaf] > nums[t] {
                    // 如果子节点大于父节点, 交换节点位置
                    nums.swapAt(leaf, t)
                }
                
                t -= 1
            }
            
            // 将最大值放到最后
            nums.swapAt(0, k)
            
            k -= 1
        }
    }
}

