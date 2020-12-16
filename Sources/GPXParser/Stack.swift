//
//  Stack.swift
//  GPXParser
//
//  Created by David Klopp on 16.12.20.
//

import Foundation

internal final class Stack<T> {
    private var _stack: [T] = []

    /**
     Push a new element on top of the stack.
     - Parameter element: Element to add to the top of the stack
     */
    func push(_ element: T) {
        self._stack.append(element)
    }

    /**
     Pop an element from the stack.
     - Return: Previous top most element or nil if none exists
     */
    func pop() -> T? {
        self._stack.popLast()
    }

    /**
     Peek at the top element on the stack.
     - Current: Previous top most element or nil if none exists
     */
    func peek() -> T? {
        return self._stack.last
    }
}
