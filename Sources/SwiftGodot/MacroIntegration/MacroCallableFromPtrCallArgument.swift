//
//  MacroCallableFromPtrCallArgument.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 18/04/2025.
//

/// Internal API. _GodotBridgeableBuiltin
@inline(__always)
@inlinable
public func _fromPtrCallArgument<T>(_ type: T.Type = T.self, _ ptr: UnsafeRawPointer?) -> T where T: _GodotBridgeableBuiltin {
    T._fromPtrCallArgument(ptr)
}

/// Internal API. Via Variant. _GodotBridgeableBuiltin?
@inline(__always)
@inlinable
public func _fromPtrCallArgument<T>(_ type: T?.Type = T?.self, _ ptr: UnsafeRawPointer?) -> T? where T: _GodotBridgeableBuiltin {
    FastVariant._fromPtrCallArgumentOrNil(ptr).to(T.self)
}

/// Internal API. Variant.
@inline(__always)
@inlinable
public func _fromPtrCallArgument(_ type: Variant.Type = Variant.self, _ ptr: UnsafeRawPointer?) -> Variant {
    Variant._fromPtrCallArgument(ptr)
}

/// Internal API. Variant?.
@inline(__always)
@inlinable
public func _fromPtrCallArgument(_ type: Variant?.Type = Variant?.self, _ ptr: UnsafeRawPointer?) -> Variant? {
    Variant?._fromPtrCallArgument(ptr)
}

/// Internal API. Arbitary VariantConvertible.
@inline(__always)
@inlinable
public func _fromPtrCallArgument<T>(_ type: T.Type = T.self, _ ptr: UnsafeRawPointer?) -> T where T: VariantConvertible {
    let variant = FastVariant?._fromPtrCallArgument(ptr)
    
    guard let result = variant.to(T.self) else {
        fatalError("Couldn't unwrap \(T.self)")
    }
    
    return result
}

/// Internal API. Arbitary VariantConvertible?.
@inline(__always)
@inlinable
public func _fromPtrCallArgument<T>(_ type: T?.Type = T?.self, _ ptr: UnsafeRawPointer?) -> T? where T: VariantConvertible {
    FastVariant?._fromPtrCallArgument(ptr).to(T.self)
}

/// Internal API. Object.
@inline(__always)
@inlinable
public func _fromPtrCallArgument<T>(_ type: T.Type = T.self, _ ptr: UnsafeRawPointer?) -> T where T: Object {
    T._fromPtrCallArgument(ptr)
}

/// Internal API. Object?
@inline(__always)
@inlinable
public func _fromPtrCallArgument<T>(_ type: T?.Type = T?.self, _ ptr: UnsafeRawPointer?) -> T? where T: Object {
    T?._fromPtrCallArgument(ptr)
}

/// Internal API. Swift Array.
@inline(__always)
@inlinable
public func _fromPtrCallArgument<T>(_ type: [T].Type = [T].self, _ ptr: UnsafeRawPointer?) -> [T] where T: _GodotBridgeableBuiltin {
    let collection = VariantCollection<T>._fromPtrCallArgument(ptr)
    
    return collection.map { $0 }
}
