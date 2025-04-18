//
//  VariantStorable.swift
//
//
//  Created by Padraig O Cinneide on 2023-10-22.
//

@_implementationOnly import GDExtension
 

/// Types that conform to VariantStorable can be stored in a Variant and can be extracted
/// back out of a Variant.
///
/// As a convenience, SwiftGodot provides conformances for some native Swift types like
/// String, Bool, Int, Float below, but you can also add your own conformances.
///
/// Every VariantStorable must be able to convert to an underlying `VariantRepresentable`
/// type which is one that can be stored natively in a `Variant`.
public protocol VariantStorable {
    associatedtype Representable: VariantRepresentable
    
    /// Creates an instance using a variant
    init?(_ variant: Variant)
    
    func toVariantRepresentable() -> Representable
}

extension VariantStorable {
    /// Unwraps an object from a variant. This is useful when you want one method to call that
    /// will return the unwrapped Variant, regardless of whether it is a SwiftGodot.Object or not.
    @available(*, deprecated, renamed: "unwrap(from:)", message: "Renamed to better reflect the semantics")
    public static func makeOrUnwrap(_ variant: Variant) -> Self? {
        return Self(variant)
    }
    
    /// Unwraps an object from a variant. This is useful when you want one method to call that
    /// will return the unwrapped Variant, regardless of whether it is a SwiftGodot.Object or not.
    public static func unwrap(from variant: Variant) -> Self? {
        return Self(variant)
    }

    /// Unwraps an object from a variant.
    @available(*, deprecated, renamed: "unwrap(from:)", message: "Renamed to better reflect the semantics")
    public static func makeOrUnwrap(_ variant: Variant?) -> Self? where Self: Object {
        return variant?.asObject()
    }
    
    /// Unwraps an object from a variant.
    public static func unwrap(from variant: Variant) -> Self? where Self: Object {
        return variant.asObject()
    }
}


extension VariantStorable {
    /// Return PropInfo for this storage type.
    static func propInfo(name: String) -> PropInfo {
        let gType = Self.Representable.godotType
        return PropInfo(
            propertyType: gType,
            propertyName: StringName(name),
            className: gType == .object ? StringName(String(describing: Self.self)) : "",
            hint: .none,
            hintStr: "",
            usage: .default
        )
    }
}

extension String: VariantStorable {
    public func toVariantRepresentable() -> GString {
        return GString(self)
    }
    
    public init?(_ variant: Variant) {
        guard let gString = GString(variant) else { return nil }
        self = gString.description
    }
}

extension Bool: VariantStorable {
    public func toVariantRepresentable() -> UInt8 {
        GDExtensionBool(self ? 1 : 0)
    }
    
    public init?(_ variant: Variant) {
        guard let gBool = GDExtensionBool(variant) else { return nil }
        self = gBool == 1
    }
}

extension Int: VariantStorable {
    public func toVariantRepresentable() -> Int64 {
        Int64(self)
    }
    
    public init?(_ variant: Variant) {
        guard let int = GDExtensionInt(variant) else { return nil }
        self = Int(int)
    }
}

extension Float: VariantStorable {
    public func toVariantRepresentable() -> Double {
        Double(self)
    }
    
    public init?(_ variant: Variant) {
        guard let value = Double(variant) else { return nil }
        self = Float(value)
    }
}
