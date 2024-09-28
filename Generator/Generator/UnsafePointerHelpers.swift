import Foundation

/// Generate methods to help marshaling arguments to Godot while keeping things civil and on stack
func generateUnsafePointerHelpers(_ p: Printer) {
    let maxNestingDepth = 16
    
    for i in 2 ..< maxNestingDepth {
        generateUnsafeRawPointersN(p, pointerCount: i)
    }
}

/// Generate a struct that serves as a stack storage for multiple pointers, so that a pointer to it can be passed to Godot as `pargs` parameter.
///
/// ```swift
/// struct UnsafeRawPointersN3 {
///     let p0: UnsafeRawPointer?
///     let p1: UnsafeRawPointer?
///     let p2: UnsafeRawPointer?
///
///     init(_ p0: UnsafeRawPointer?, _ p1: UnsafeRawPointer?, _ p2: UnsafeRawPointer?) {
///         self.p0 = p0
///         self.p1 = p1
///         self.p2 = p2
///     }
/// }
/// ```

private func generateUnsafeRawPointersN(_ p: Printer, pointerCount count: Int) {
    p("struct UnsafeRawPointersN\(count)") {
        for i in 0 ..< count {
            p("let p\(i): UnsafeRawPointer?")
        }
        
        let args = (0 ..< count)
            .map { "_ p\($0): UnsafeRawPointer?" }
            .joined(separator: ", ")
        
        p("")
        
        p("init(\(args))") {
            for i in 0 ..< count {
                p("self.p\(i) = p\(i)")
            }
        }
    }
}
