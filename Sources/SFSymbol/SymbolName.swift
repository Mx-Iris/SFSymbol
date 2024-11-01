import Foundation

@available(*, deprecated, renamed: "SFSymbol.SymbolName", message: "Use SFSymbol.SymbolName")
public typealias SymbolName = SFSymbol.SymbolName

extension SFSymbol {
    public protocol SymbolName {
        var rawValue: String { get }
        var bundle: Bundle? { get }
    }
}

extension SFSymbol.SymbolName {
    public var bundle: Bundle? { nil }
}
