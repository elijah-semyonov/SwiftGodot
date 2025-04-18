//
//  MacroCallableWrapResult.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 11/04/2025.
//

/// Internal API. VariantConvertible.
@inline(__always)
@inlinable
public func _wrapResult<T>(_ value: T) -> FastVariant? where T: VariantConvertible {
    value.toFastVariant()
}

/// Internal API. VariantConvertible?.
@inline(__always)
@inlinable
public func _wrapResult<T>(_ value: T?) -> FastVariant? where T: VariantConvertible {
    value.toFastVariant()
}

/// Internal API. Object.
@inline(__always)
@inlinable
public func _wrapResult<T>(_ value: T) -> FastVariant? where T: Object {
    value.toFastVariant()
}

/// Internal API. Object?.
@inline(__always)
@inlinable
public func _wrapResult<T>(_ value: T?) -> FastVariant? where T: Object {
    value.toFastVariant()
}

/// Internal API. Variant
@inline(__always)
@inlinable
public func _wrapResult(_ value: Variant) -> FastVariant? {
    return value.toFastVariant()
}

/// Internal API. Variant?
@inline(__always)
@inlinable
public func _wrapResult(_ value: Variant?) -> FastVariant? {
    return value.toFastVariant()
}

/// Internal API. Swift Array.
@inline(__always)
@inlinable
public func _wrapResult<T>(_ value: [T]) -> FastVariant? where T: _GodotBridgeable {
    let array = GArray(T.self)
    for element in value {
        array.append(element.toVariant())
    }
    
    return array.toFastVariant()
}

/// Internal API. ObjectCollection.
@inline(__always)
@inlinable
public func _wrapResult<T>(_ value: ObjectCollection<T>) -> FastVariant? where T: _GodotBridgeable {
    value.toFastVariant()
}

/// Internal API. VariantCollection.
@inline(__always)
@inlinable
public func _wrapResult<T>(_ value: VariantCollection<T>) -> FastVariant? where T: _GodotBridgeable {
    value.toFastVariant()
}

/// Internal API. Void.
@inline(__always)
@inlinable
public func _wrapResult(_ value: Void) -> FastVariant? {
    return nil
}

@available(*, unavailable, message: "Type cannot be returned from @Callable")
@_disfavoredOverload
public func _wrapResult<T>(_ value: T?) -> FastVariant? {
    fatalError("Unreachable")
}
