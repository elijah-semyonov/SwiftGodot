//
//  File.swift
//  
//
//  Created by Miguel de Icaza on 9/25/23.
//

import Foundation
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension FunctionDeclSyntax {
    var hasClassOrStaticModifier: Bool {
        modifiers.contains { modifier in
            switch modifier.name.tokenKind {
            case .keyword(let keyword):
                switch keyword {
                case .static, .class:
                    return true
                default:
                    return false
                }
            default:
                return false
            }
        }
    }
}

extension FunctionParameterSyntax {
    // (_ arg: Int) -> ""
    // (arg: Int) -> "arg: "
    var callSiteLabel: String {
        let first = firstName.text
        return first != "_" ? "\(first): " : ""
    }
}

enum CallableConvention: String, CaseIterable {
    case call
    case callptr
    
    var earlyReturnExpr: String {
        switch self {
        case .call:
            return "return nil"
        case .callptr:
            return "return"
        }
    }
    
    func argumentStatement(type: String, index: Int) -> String {
        switch self {
        case .call:
            return "let arg\(index) = try arguments.argument(ofType: \(type).self, at: \(index))"
        case .callptr:
            return "let arg\(index) = SwiftGodot._fromPtrCallArgument(\(type).self, arguments[\(index)])"
        }
    }
    
    func finalStatement(receiver: String, funcName: String, callArgs: String) -> String {
        switch self {
        case .call:
            return "return SwiftGodot._wrapResult(\(receiver).\(funcName)(\(callArgs)))"
        case .callptr:
            return "SwiftGodot._intoPtrCallReturnValue(\(receiver).\(funcName)(\(callArgs)), pReturnValue)"
        }
    }
    
    func signature(funcName: String) -> String {
        switch self {
        case .call:
            return "static func _mproxy_call_\(funcName)(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodot.Arguments) -> SwiftGodot.FastVariant?"
        case .callptr:
            return "static func _mproxy_ptrcall_\(funcName)(pInstance: UnsafeRawPointer?, arguments: UnsafePointer<UnsafeRawPointer?>?, pReturnValue: UnsafeMutableRawPointer?)"
        }
    }
}

public struct GodotCallable: PeerMacro {
    static func process(funcDecl: FunctionDeclSyntax) throws -> [DeclSyntax] {
        let funcName = funcDecl.name.text
        
        let isStatic = funcDecl.hasClassOrStaticModifier
        
        if let effects = funcDecl.signature.effectSpecifiers,
           effects.asyncSpecifier?.presence == .present ||
            effects.throwsClause?.throwsSpecifier.presence == .present {
            throw GodotMacroError.unsupportedCallableEffect
        }
        
        let parameters = funcDecl.signature.parameterClause.parameters
        
        var result: [DeclSyntax] = []
        
        for convention in CallableConvention.allCases {
            var body = ""
            var callArgsList: [String] = []
            
            // Is there are no arguments, or conventions is `callptr` there is no do-catch scope to sanitize arguments access
            let indentation = parameters.isEmpty || convention == .callptr ? "" : "    "
            
            // If there are arguments, unwrap arguments buffer pointer first for `callptr`
            if convention == .callptr, !parameters.isEmpty {
                body += """
                    guard let arguments else {
                        fatalError("\(funcName) expected \(parameters.count) argument(s), received null pointer arguments buffer")
                    }
                """
            }
            
            if !isStatic {
                body += """
                \(indentation)    guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                \(indentation)        SwiftGodot.GD.printErr("Error calling `\(funcName)`: failed to unwrap instance \\(String(describing: pInstance))")
                \(indentation)        \(convention.earlyReturnExpr)
                \(indentation)    }
                """
            }
            
            let objectOrSelf = isStatic ? "self" : "object"
            
            for (index, parameter) in parameters.enumerated() {
                body += """
                        \(convention.argumentStatement(type: parameter.type.description, index: index))
                """

                callArgsList.append("\(parameter.callSiteLabel)arg\(index)")
            }
            
            let callArgs = callArgsList.joined(separator: ", ")
            
            body += """
            \(indentation)    \(convention.finalStatement(receiver: objectOrSelf, funcName: funcName, callArgs: callArgs))
            """
            
            if parameters.isEmpty {
                result.append("""
                \(raw: convention.signature(funcName: funcName)) {
                \(raw: body)                
                }
                """)
            } else {
                let signature = convention.signature(funcName: funcName)
                switch convention {
                case .call:
                    result.append("""
                    \(raw: signature) {
                        do { // safe arguments access scope
                    \(raw: body)        
                        } catch {
                            SwiftGodot.GD.printErr("Error calling `\(raw: funcName)`: \\(error.description)")                    
                        }
                    
                        return nil
                    }
                    """)
                case .callptr:
                    result.append("""
                    \(raw: signature) {                        
                    \(raw: body)                                
                    }
                    """)
                }
            }
        }
        
        return result
    }
    
    
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            let classError = Diagnostic(node: declaration.root, message: GodotMacroError.requiresFunction)
            context.diagnose(classError)
            return []
        }
        
        return try process(funcDecl: funcDecl)
    }
    
}
