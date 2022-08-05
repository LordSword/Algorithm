//
//  Balanced BinaryTree.swift
//  Test
//
//  Created by Sword on 2022/7/11.
//

import Foundation

class AVLNode {
    var data: Int
    // 相对高度
    var height: Int
    // 父节点
    var parent: AVLNode?
    // 左子节点
    var left: AVLNode?
    // 右子节点
    var right: AVLNode?
    
    init(_ data: Int) {
        self.data = data
        self.height = 1
    }
    
    /// 计算高度
    func calHeight() -> Int {
        
        if nil == left, let right = right {
            return right.height + 1
        }
        
        if nil == right, let left = left {
            return left.height + 1
        }
        
        if let left = left, let right = right {
            return max(left.height, right.height) + 1
        }
        
        return 1
    }
    
    /// 计算BF (Balance Factor)
    func calBF() -> Int {
        if nil == left, let right = right {
            return -right.height
        }
        
        if nil == right, let left = left {
            return left.height
        }
        
        if let left = left, let right = right {
            return left.height - right.height
        }
        
        return 0
    }
    
    /// 左旋转
    func leftRotate() -> AVLNode {
        guard let newRoot = self.right else {
            return self
        }
        
        let oldRoot = self
        let parent = self.parent
        // 1、替换掉root
        if let parent = parent {
            // 判断当前是左节点还是右节点
            if oldRoot.data > parent.data {
                parent.right = newRoot
            } else {
                parent.left = newRoot
            }
        }
        newRoot.parent = parent
        
        // 2、重新组装oldRoot
        oldRoot.right = newRoot.left
        newRoot.left?.parent = oldRoot
        
        // 3、OldRoot为NewRoot的左子树
        newRoot.left  = oldRoot
        oldRoot.parent = newRoot
        
        // 刷新高度
        oldRoot.height = oldRoot.calHeight()
        newRoot.height = newRoot.calHeight()
        
        return newRoot
    }
    
    /// 右旋转
    func rightRotate() -> AVLNode {
        guard let newRoot = self.left else {
            return self
        }
        
        let oldRoot = self
        let parant = self.parent
        // 1、替换掉root
        if let parant = parant {
            if parant.data > oldRoot.data {
                parant.left = newRoot
            } else {
                parant.right = newRoot
            }
        }
        newRoot.parent = parant
        
        // 2、重新组装OldRoot
        oldRoot.left = newRoot.right
        newRoot.right?.parent = oldRoot
        
        // 3、OldRoot为NewRoot的右子树
        newRoot.right = oldRoot
        oldRoot.parent = newRoot
        
        // 刷新高度
        oldRoot.height = oldRoot.calHeight()
        newRoot.height = newRoot.calHeight()
        
        return newRoot
    }
}

class AVLTree {
    var root: AVLNode?
    
    func insert(_ data: Int) {
        guard let root = root else {
            root = AVLNode(data)
            return
        }
    
        self.root = insert(root, data: data)
    }
    
    @discardableResult
    private func insert(_ root: AVLNode, data: Int) -> AVLNode {
        
        var newRoot = root
        
        if data < newRoot.data {
            // 插入左树
            if let left = newRoot.left {
                insert(left, data: data)
            } else {
                newRoot.left = AVLNode(data)
                newRoot.left?.parent = newRoot
            }
        } else if (data > newRoot.data) {
            // 插入右树
            if let right = newRoot.right {
                insert(right, data: data)
            } else {
                newRoot.right = AVLNode(data)
                newRoot.right?.parent = newRoot
            }
        }
        
        // 刷新高度
        newRoot.height = newRoot.calHeight()
        
        // LL型 右旋转
        if 2 == newRoot.calBF() {
            // LR型 先左后右
            if let left = newRoot.left, -1 == left.calBF() {
                newRoot.left = left.leftRotate()
            }
            newRoot = newRoot.rightRotate()
        }
        
        // RR型 左旋转
        if -2 == newRoot.calBF() {
            // RL型 先右后左
            if let right = newRoot.right, 1 == right.calBF() {
                newRoot.right = right.rightRotate()
            }
            newRoot = newRoot.leftRotate()
        }
        
        return newRoot
    }
    
    func printTree(_ root: AVLNode?) {
        guard let root = root else {
            return
        }
        
        printTree(root.left)
        print("\(root.data) height:\(root.height)")
        printTree(root.right)
    }
}
