//
//  File.swift
//  
//
//  Created by Miguel de Icaza on 3/24/23.
//

@_implementationOnly import GDExtension

/// If your application is crashing due to the Variant leak fixes, please
/// enable this flag, and provide me with a test case, so I can find that
/// pesky scenario.
public var experimentalDisableVariantUnref = false

/// 24-bytes payload of ``Variant`` in `float_64` configuration
struct GodotContent24: Equatable {
    let w0: UInt64
    let w1: UInt64
    let w2: UInt64
}

/// Variant objects box various Godot Objects, you create them with one of the
/// constructors, and you can retrieve the contents using the various extension
/// constructors that are declared on the various types that are wrapped.
///
/// You can retrieve the type of a variant from the ``gtype`` property.
///
/// A Variant takes up only 20 bytes and can store almost any engine datatype
/// inside of it. Variants are rarely used to hold information for long periods of
/// time. Instead, they are used mainly for communication, editing, serialization and
/// moving data around.
///
/// A Variant:
/// - Can store almost any Godot engine datatype.
/// - Can perform operations between many variants. GDScript uses Variant as its atomic/native datatype.
/// - Can be hashed, so it can be compared to other variants.
/// - Can be used to convert safely between datatypes.
/// - Can be used to abstract calling methods and their arguments. Godot exports all its functions through variants.
/// - Can be used to defer calls or move data between threads.
/// - Can be serialized as binary and stored to disk, or transferred via network.
/// - Can be serialized to text and use it for printing values and editable settings.
/// - Can work as an exported property, so the editor can edit it universally.
/// - Can be used for dictionaries, arrays, parsers, etc.
///
/// > Note: Containers (``GArray`` and ``GDictionary``): Both are implemented using variants.
/// A ``GDictionary`` can match any datatype used as key to any other datatype.  An ``GArray``
/// just holds an array of Variants.  A ``Variant`` can also hold a ``GDictionary`` and an ``GArray``
/// inside.
///
/// Modifications to a container will modify all references to it.

public class Variant: Hashable, Equatable, CustomDebugStringConvertible, ExpressibleByNilLiteral {
    static var fromTypeMap: [GDExtensionVariantFromTypeConstructorFunc] = {
        var map: [GDExtensionVariantFromTypeConstructorFunc] = []
        
        for vtype in 0..<Variant.GType.max.rawValue {
            let v = GDExtensionVariantType.RawValue (vtype == 0 ? 1 : vtype)
            map.append (gi.get_variant_from_type_constructor (GDExtensionVariantType (v))!)
        }
        return map
    }()
    
    static var toTypeMap: [GDExtensionTypeFromVariantConstructorFunc] = {
        var map: [GDExtensionTypeFromVariantConstructorFunc] = []
        
        for vtype in 0..<Variant.GType.max.rawValue {
            let v = GDExtensionVariantType.RawValue (vtype == 0 ? 1 : vtype)
            map.append (gi.get_variant_to_type_constructor (GDExtensionVariantType (v))!)
        }
        return map
    }()
    
    typealias ContentType = GodotContent24
    static let zero = ContentType(w0: 0, w1: 0, w2: 0)
    
    var content = Variant.zero
    
    /// Initializes from the raw contents of another Variant, this will make a copy of the variant contents
    init(copying otherContent: ContentType) {
        withUnsafePointer(to: otherContent) { src in
            gi.variant_new_copy(&content, src)
        }
    }
    
    /// Allow expressions like `let variant: Variant = nil`
    public required convenience init(nilLiteral: Void) {
        self.init()
    }
    
    /// Initializes using `ContentType` and assuming that this `Variant` is sole owner of this content now.
    init(takingOver other: ContentType) {
        self.content = other
    }

    deinit {
        if experimentalDisableVariantUnref { return }
        gi.variant_destroy (&content)
    }
    
    /// Creates an empty Variant, that represents the Godot type `nil`
    public init() {
        // no-op
    }

    /// Compares two variants, does this by delegating the comparison to Godot
    public static func == (lhs: Variant, rhs: Variant) -> Bool {
        var valid = GDExtensionBool (0)
        let ret = Variant (false)
        
        gi.variant_evaluate (GDEXTENSION_VARIANT_OP_EQUAL, &lhs.content, &rhs.content, &ret.content, &valid)
        return Bool (ret) ?? false
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(gi.variant_hash (&content))
    }
    
    /// Creates a new Variant based on a copy of the reference variant passed in
    public init (_ other: Variant) {
        withUnsafeMutablePointer(to: &content) { selfPtr in
            withUnsafePointer(to: other.content) { ptr in
                gi.variant_new_copy(selfPtr, ptr)
            }
        }
    }
    
    convenience public init(_ value: some VariantStorable) {
        self.init(representable: value.toVariantRepresentable())
    }
    
    convenience public init(_ value: (some VariantStorable)?) {
        if let value {
            self.init(value)
        } else {
            self.init()
        }
    }
    
    private init<T: VariantRepresentable>(representable value: T) {
        let godotType = T.godotType
        
        withUnsafeMutablePointer(to: &content) { selfPtr in
            var mutableValue = value.content
            withUnsafeMutablePointer(to: &mutableValue) { ptr in
                Variant.fromTypeMap [Int (godotType.rawValue)] (selfPtr, ptr)
            }
        }
    }
    
    /// This describes the type of the data wrapped by this variant
    public var gtype: GType {
        var copy = content
        return GType (rawValue: Int64 (gi.variant_get_type (&copy).rawValue)) ?? .nil
    }
    
    /// Extract the content of this Variant into a value pointed by `dst`, assuming this ``Variant`` contains ``GType`` equal to `gtype` and the
    /// `dst` is pointing at the storage compatible with this `gtype`.
    /// `dst` pointee is unowned content, so the caller should take the ownership over it.
    func read(into dst: UnsafeMutableRawPointer, assumingType gtype: GType) {
        withUnsafeMutablePointer(to: &content) { src in
            Variant.toTypeMap[Int (gtype.rawValue)](dst, src)
        }
    }
    
    /// Return true if this ``Variant`` contains  Godot `Nil` (`gtype == .nil`)
    public var isNil: Bool {
        // Hard-coded and works on assumption that `gi.variant_new_nil` is the same as `Self.zero` and doesn't have
        // additional logic on Godot side
        content == Variant.zero
    }
    
    /// Returns true if the variant is flagged as being an object (`gtype == .object`) and it has a nil pointer.
    public var isNull: Bool {
        return asObject(Object.self) == nil
    }
    
    ///
    /// Attempts to cast the Variant into a SwiftGodot.Object, if the variant contains a value of type `.object`, then
    // this will return the object.  If the variant contains the nil value, or the content of the variant is not
    /// a `.object, the value `nil` is returned.
    ///
    /// - Parameter type: the desired type eg. `.asObject(Node.self)`
    /// - Returns: nil on error, or the type on success
    ///
    public func asObject<T: Object> (_ type: T.Type = T.self) -> T? {
        guard gtype == .object else {
            return nil
        }
        var handle: UnsafeRawPointer?
        read(into: &handle, assumingType: .object)
        
        guard let handle else {
            return nil
        }
        
        let ret: T? = lookupObject(nativeHandle: handle)
        return ret
    }
    
    public var description: String {
        var ret = GDExtensionStringPtr (bitPattern: 0xdeaddead)
        gi.variant_stringify (&content, &ret)
        
        let str = stringFromGodotString(&ret)
        GString.destructor (&ret)
        return str ?? ""
    }
    
    public var debugDescription: String {
        "\(gtype) [\(description)]"
    }
    
    /// Invokes a variant's method by name.
    /// - Parameters:
    ///  - method: name of the method to invoke
    ///  - arguments: variable list of arguments to pass to the method
    /// - Returns: on success, the variant result, on error, the reason
    public func call(method: StringName, _ arguments: Variant...) -> Result<Variant, CallErrorType> {
        var result = Variant.zero
        
        // Shadow self.content, we just need a copy of it locally
        var content = content
        
        var err = GDExtensionCallError()
        
        if arguments.count == 1 {
            var argContent = arguments.first!.content
            withUnsafePointer(to: &argContent) { ptr in
                gi.variant_call(&content, &method.content, ptr, 1, &result, &err)
            }
        } else if arguments.count > 1 {
            // A temporary allocation containing pointers to `Variant.ContentType` of marshaled arguments
            withUnsafeTemporaryAllocation(of: UnsafeRawPointer?.self, capacity: arguments.count) { pArgsBuffer in
                // We use entire buffer so can initialize every element in the end. It's not
                // necessary for UnsafeRawPointer and other POD types (which Variant.ContentType also is)
                // but we'll do it for the sake of correctness
                defer { pArgsBuffer.deinitialize() }
                guard let pArgs = pArgsBuffer.baseAddress else {
                    fatalError("pargsBuffer.baseAddress is nil")
                }
                             
                // A temporary allocation containing `Variant.ContentType` of marshaled arguments
                withUnsafeTemporaryAllocation(of: Variant.ContentType.self, capacity: arguments.count) { contentsBuffer in
                    defer { contentsBuffer.deinitialize() }
                    guard let contentsPtr = contentsBuffer.baseAddress else {
                        fatalError("contentsBuffer.baseAddress is nil")
                    }
                    
                    for i in 0..<arguments.count {
                        // Copy `content`s of the variadic `Variant`s into `contentBuffer`
                        contentsBuffer.initializeElement(at: i, to: arguments[i].content)
                        
                        // Initialize `pArgs` elements to point at respective contents of `contentsBuffer`
                        pArgsBuffer.initializeElement(at: i, to: contentsPtr + i)
                    }
                    
                    gi.variant_call(&content, &method.content, pArgs, Int64(arguments.count), &result, &err)
                }
            }
        } else {
            gi.variant_call(&content, &method.content, nil, 0, &result, &err)
        }
        
        if err.error != GDEXTENSION_CALL_OK {
            return .failure(toCallErrorType(err.error))
        }
        
        return .success(Variant(takingOver: result))
    }
    
    /// Errors raised by the variant subscript
    ///
    /// There are two possible error conditions, an attempt to use an indexer on a variant that is not
    /// an array, or an attempt to access an element out bounds.
    public enum VariantIndexerError: Error, CustomDebugStringConvertible {
        case ok
        /// The variant is not an array
        case invalidOperation
        /// The index is out of bounds
        case outOfBounds
        
        public var debugDescription: String {
            switch self {
            case .ok:
                return "Success"
            case .invalidOperation:
                return "Attempt to use indexer methods in a variant that does not support it"
            case .outOfBounds:
                return "Index value was out of bounds"
            }
        }
    }
    
    /// Variants that represent arrays can be indexed, this subscript allows you to fetch the individual elements of those arrays
    ///
    public subscript(index: Int) -> Variant {
        get {
            var result = Variant.zero
            var valid: GDExtensionBool = 0
            var oob: GDExtensionBool = 0
            
            gi.variant_get_indexed(&content, Int64(index), &result, &valid, &oob)
            if valid == 0 || oob != 0 {
                return nil
            }
                        
            return Variant(takingOver: result)
        }
        set {
            var newValueContent = newValue.content
            
            var valid: GDExtensionBool = 0
            var oob: GDExtensionBool = 0

            gi.variant_set_indexed(&content, Int64(index), &newValueContent, &valid, &oob)
        }
    }
    
    
    /// Gets the name of a Variant type.
    public static func typeName(_ type: GType) -> String {
        let res = GString()
        gi.variant_get_type_name (GDExtensionVariantType (GDExtensionVariantType.RawValue(type.rawValue)), &res.content)
        let ret = GString.stringFromGStringPtr(ptr: &res.content)
        return ret ?? ""
    }
}
