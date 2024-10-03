/// A lightweight non-copyable storage for arguments marshalled to implementations where a sequence of `Variant`s is expected.
/// If you need a copy of `Variant`s inside, you can construct an array using `Array.init(_ args: borrowing Arguments)`
/// Elements can be accessed using subscript operator.
public struct Arguments: ~Copyable {
    enum Contents {
        struct UnsafeGodotArgs {
            let pArgs: UnsafePointer<UnsafeRawPointer?>
            let count: Int
            
            var first: Variant {
                retrieveVariant(at: 0)
            }
            
            /// Lazily reconstruct variant at `index`
            func retrieveVariant(at index: Int) -> Variant {
                guard index >= 0 && index < count else {
                    return nil
                }
                
                guard let ptr = pArgs[index] else {
                    return Variant()
                }
                
                return Variant(copying: ptr.assumingMemoryBound(to: Variant.ContentType.self).pointee)
            }
        }
        /// User constructed and passed an array, reuse it
        /// It's also cheap to use in a case with no arguments, Swift array impl will just hold a null pointer inside.
        case array([Variant])
        
        /// Godot passed internally managed buffer, retrieve values lazily
        case unsafeGodotArgs(UnsafeGodotArgs)
    }
    
    let contents: Contents
    
    /// Arguments count
    public var count: Int {
        switch contents {
        case .array(let array):
            return array.count
        case .unsafeGodotArgs(let contents):
            return contents.count
        }
    }
    
    /// The first argument.
    ///
    /// If the `Arguments` is empty, the value of this property is `nil`.
    public var first: Variant {
        switch contents {
        case .unsafeGodotArgs(let contents):
            if contents.count > 0 {
                return contents.retrieveVariant(at: 0)
            } else {
                return nil
            }
        case .array(let array):
            if let first = array.first {
                return first
            } else {
                return nil
            }
        }
    }
    
    init(from array: [Variant]) {
        contents = .array(array)
    }
    
    init(pArgs: UnsafePointer<UnsafeRawPointer?>?, count: Int64) {
        if let pArgs, count > 0 {
            contents = .unsafeGodotArgs(.init(pArgs: pArgs, count: Int(count)))
        } else {
            contents = .array([])
        }
    }
    
    init() {
        contents = .array([])
    }
    
    public subscript(_ index: Int) -> Variant {
        get {
            switch contents {
            case .array(let array):
                guard index >= 0, index < array.count else {
                    return nil
                }
                return array[index]
            case .unsafeGodotArgs(let args):
                return args.retrieveVariant(at: index)
            }
        }
    }
}

/// Execute `body` and return the result of executing it taking temporary storage keeping Godot managed `Variant`s stored in `pargs`.
func withArguments<T>(pArgs: UnsafePointer<UnsafeRawPointer?>?, count: Int64, _ body: (borrowing Arguments) -> T) -> T {
    let arguments = Arguments(pArgs: pArgs, count: count)
    let result = body(arguments)
    return result
}

func withArguments<T>(from array: [Variant], _ body: (borrowing Arguments) -> T) -> T {
    body(Arguments(from: array))
}

public extension Array where Element == Variant {
    init(_ args: borrowing Arguments) {
        switch args.contents {
        case .array(let array):
            self = array
        case .unsafeGodotArgs(let args):
            self = (0..<args.count).map { i in
                args.retrieveVariant(at: i)
            }
        }
    }
}
