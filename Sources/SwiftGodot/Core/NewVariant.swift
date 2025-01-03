//
//  NewVariant.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 03/01/2025.
//

struct UnsafeVariantGuts {
    static let nilVariantGuts = UnsafeVariantGuts(w0: 0, w1: 0, w2: 0)
    
    var w0: UInt64
    var w1: UInt64
    var w2: UInt64        
    
    func destroy() {
        var copy = self
        withUnsafeMutablePointer(to: &copy) { ptr in
            gi.variant_destroy(ptr)
        }
    }
}

public protocol NewVariantConvertible {
    static func from(_ variant: NewVariant) -> Self?
    
    func intoVariant() -> NewVariant
}

public extension NewVariantConvertible {
    static func fromVariant(_ variant: NewVariant?) -> Self? {
        if let variant {
            return from(variant)
        } else {
            return nil
        }
    }
}

public enum NewVariant {
    case bool(Bool)
    case int(Int)
    case float(Float)
    case string(String)
    case vector2(Vector2)
    case vector2i(Vector2i)
    case vector3(Vector3)
    case vector3i(Vector3i)
    case transform2d(Transform2D)
    case vector4(Vector4)
    case vector4i(Vector4i)
    case plane(Plane)
    case quaternion(Quaternion)
    case aabb(AABB)
    case basis(Basis)
    case transform3d(Transform3D)
    case projection(Projection)
    case color(Color)
    case stringName(StringName)
    case nodePath(NodePath)
    case rid(RID)
    case object(Object)
    case callable(Callable)
    case signal(Signal)
    case dictionary(GDictionary)
    case array(GArray)
    case packedByteArray(PackedByteArray)
    case packedInt32Array(PackedInt32Array)
    case packedInt64Array(PackedInt64Array)
    case packedStringArray(PackedStringArray)
    case packedVector2Array(PackedVector2Array)
    case packedVector3Array(PackedVector3Array)
    case packedColorArray(PackedColorArray)
    case packedVector4Array(PackedVector4Array)
    
    public func into<T>(_ type: T.Type = T.self) -> T? where T: NewVariantConvertible {
        T.from(self)
    }
    
    public static func from<T>(_ value: T) -> Self where T: NewVariantConvertible {
        value.intoVariant()
    }
}

public extension Optional where Wrapped == NewVariant {
    static func from<T>(_ value: T?) -> Self? where T: NewVariantConvertible {
        value?.intoVariant()
    }
    
    func into<T>(_ type: T?.Type = T?.self) -> T? where T: NewVariantConvertible {
        if let self {
            if let value = self.into(T.self) {
                return value
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

extension Bool: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Bool? {
        guard case let .bool(value) = variant else { return nil }
        return value
    }
    
    public func intoVariant() -> NewVariant {
        .bool(self)
    }
}

extension Int: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Int? {
        guard case let .int(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .int(self)
    }
}

extension Float: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Float? {
        guard case let .float(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .float(self)
    }
}

extension String: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> String? {
        guard case let .string(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .string(self)
    }
}

extension Vector2: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector2? {
        guard case let .vector2(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector2(self)
    }
}

extension Vector2i: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector2i? {
        guard case let .vector2i(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector2i(self)
    }
}

extension Vector3: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector3? {
        guard case let .vector3(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector3(self)
    }
}

extension Vector3i: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector3i? {
        guard case let .vector3i(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector3i(self)
    }
}

extension Transform2D: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Transform2D? {
        guard case let .transform2d(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .transform2d(self)
    }
}

extension Vector4: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector4? {
        guard case let .vector4(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector4(self)
    }
}

extension Vector4i: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector4i? {
        guard case let .vector4i(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector4i(self)
    }
}

extension Plane: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Plane? {
        guard case let .plane(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .plane(self)
    }
}

extension Quaternion: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Quaternion? {
        guard case let .quaternion(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .quaternion(self)
    }
}

extension AABB: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> AABB? {
        guard case let .aabb(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .aabb(self)
    }
}

extension Basis: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Basis? {
        guard case let .basis(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .basis(self)
    }
}

extension Transform3D: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Transform3D? {
        guard case let .transform3d(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .transform3d(self)
    }
}

extension Projection: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Projection? {
        guard case let .projection(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .projection(self)
    }
}

extension Color: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Color? {
        guard case let .color(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .color(self)
    }
}

extension StringName: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> StringName? {
        guard case let .stringName(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .stringName(self)
    }
}

extension NodePath: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> NodePath? {
        guard case let .nodePath(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .nodePath(self)
    }
}

extension RID: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> RID? {
        guard case let .rid(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .rid(self)
    }
}

extension Object: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .object(value) = variant else { return nil }
        return value as? Self
    }

    public func intoVariant() -> NewVariant {
        .object(self)
    }
}

extension Callable: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Callable? {
        guard case let .callable(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .callable(self)
    }
}

extension Signal: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> Signal? {
        guard case let .signal(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .signal(self)
    }
}

extension GDictionary: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> GDictionary? {
        guard case let .dictionary(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .dictionary(self)
    }
}

extension GArray: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> GArray? {
        guard case let .array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .array(self)
    }
}

extension PackedByteArray: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedByteArray? {
        guard case let .packedByteArray(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedByteArray(self)
    }
}

extension PackedInt32Array: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedInt32Array? {
        guard case let .packedInt32Array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedInt32Array(self)
    }
}

extension PackedInt64Array: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedInt64Array? {
        guard case let .packedInt64Array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedInt64Array(self)
    }
}

extension PackedStringArray: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedStringArray? {
        guard case let .packedStringArray(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedStringArray(self)
    }
}

extension PackedVector2Array: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedVector2Array? {
        guard case let .packedVector2Array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedVector2Array(self)
    }
}

extension PackedVector3Array: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedVector3Array? {
        guard case let .packedVector3Array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedVector3Array(self)
    }
}

extension PackedColorArray: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedColorArray? {
        guard case let .packedColorArray(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedColorArray(self)
    }
}

extension PackedVector4Array: NewVariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedVector4Array? {
        guard case let .packedVector4Array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedVector4Array(self)
    }
}
