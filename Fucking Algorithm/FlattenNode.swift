//
//  FlattenNode.swift
//  Test
//
//  Created by Sword on 2021/9/24.
//

import Cocoa

public class FlattenNode {

    // Definition for a Node.
    public var val: Int
    public var prev: FlattenNode?
    public var next: FlattenNode?
    public var child: FlattenNode?
    public init(_ val: Int) {
        self.val = val
        self.prev = nil
        self.next = nil
        self.child  = nil
    }
}
