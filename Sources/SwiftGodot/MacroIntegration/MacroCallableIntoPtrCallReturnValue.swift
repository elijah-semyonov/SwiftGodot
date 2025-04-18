//
//  MacroCallableIntoPtrCallReturnValue.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 18/04/2025.
//

/// Internal API. _GodotBridgeableBuiltin.
@inline(__always)
@inlinable
public func _intoPtrCallReturnValue<T>(_ value: T, _ pReturnValue: UnsafeMutableRawPointer?) where T: _GodotBridgeableBuiltin {
    guard let pReturnValue else {
        fatalError("Can't write \(T.self) into null return value pointer")
    }
    
    value._intoPtrCallReturnValue(pReturnValue)
}

/// Internal API. _GodotBridgeableBuiltin?, via Variant
@inline(__always)
@inlinable
public func _intoPtrCallReturnValue<T>(_ value: T?, _ pReturnValue: UnsafeMutableRawPointer?) where T: _GodotBridgeableBuiltin {
    guard let pReturnValue else {
        fatalError("Can't write \(T?.self) into null return value pointer")
    }
    
    value.toFastVariant()._intoPtrCallReturnValue(pReturnValue)
}

/// Internal API. Arbitary VariantConvertible.
@inline(__always)
@inlinable
public func _intoPtrCallReturnValue<T>(_ value: T, _ pReturnValue: UnsafeMutableRawPointer?) where T: VariantConvertible {
    guard let pReturnValue else {
        fatalError("Can't write \(T.self) into null return value pointer")
    }
    
    value.toFastVariant()._intoPtrCallReturnValue(pReturnValue)
}

/// Internal API. Arbitary VariantConvertible?.
@inline(__always)
@inlinable
public func _intoPtrCallReturnValue<T>(_ value: T?, _ pReturnValue: UnsafeMutableRawPointer?) where T: VariantConvertible {
    guard let pReturnValue else {
        fatalError("Can't write \(T?.self) into null return value pointer")
    }

    value.toFastVariant()._intoPtrCallReturnValue(pReturnValue)
}

/// Internal API. Variant?
@inline(__always)
@inlinable
public func _intoPtrCallReturnValue(_ value: Variant?, _ pReturnValue: UnsafeMutableRawPointer?) {
    guard let pReturnValue else {
        fatalError("Can't write \(Variant?.self) into null return value pointer")
    }
    
    value._intoPtrCallReturnValue(pReturnValue)
}

/// Internal API. Variant
@inline(__always)
@inlinable
public func _intoPtrCallReturnValue(_ value: Variant, _ pReturnValue: UnsafeMutableRawPointer?) {
    guard let pReturnValue else {
        fatalError("Can't write \(Variant.self) into null return value pointer")
    }
    
    value._intoPtrCallReturnValue(pReturnValue)
}

/// Internal API. Object
@inline(__always)
@inlinable
public func _intoPtrCallReturnValue<T>(_ value: T, _ pReturnValue: UnsafeMutableRawPointer?) where T: Object {
    guard let pReturnValue else {
        fatalError("Can't write \(T.self) into null return value pointer")
    }
    
    value._intoPtrCallReturnValue(pReturnValue)
}

/// Internal API. Object?
@inline(__always)
@inlinable
public func _intoPtrCallReturnValue<T>(_ value: T?, _ pReturnValue: UnsafeMutableRawPointer?) where T: Object {
    guard let pReturnValue else {
        fatalError("Can't write \(T?.self) into null return value pointer")
    }
    value._intoPtrCallReturnValue(pReturnValue)
}


/// Internal API. Swift Array.
@inline(__always)
@inlinable
public func _intoPtrCallReturnValue<T>(_ value: [T], _ pReturnValue: UnsafeMutableRawPointer?) where T: _GodotBridgeable {
    guard let pReturnValue else {
        fatalError("Can't write \([T].self) into null return value pointer")
    }
    
    let array = GArray(T.self)
    for element in value {
        array.append(element.toFastVariant())
    }
    
    array._intoPtrCallReturnValue(pReturnValue)
}

/// Internal API. Void.
@inline(__always)
@inlinable
public func _intoPtrCallReturnValue(_ value: Void, _ pReturnValue: UnsafeMutableRawPointer?) {
    // no-op
}

/// Internal API. Catch all for unsupported types.
@_disfavoredOverload
@available(*, unavailable, message: "Unsupported type")
public func _intoPtrCallReturnValue(_ value: (any Any)?, _ pReturnValue: UnsafeMutableRawPointer?) {
    fatalError("Unreachable")
}

