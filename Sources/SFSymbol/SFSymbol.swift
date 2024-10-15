#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

/// extension SFSymbol {
public typealias NSUIImage = NSImage
public typealias NSUIFont = NSFont
public typealias NSUIColor = NSColor
public typealias NSUISymbolConfiguration = NSImage.SymbolConfiguration
public typealias NSUISymbolWeight = NSFont.Weight
public typealias NSUISymbolScale = NSImage.SymbolScale
public typealias NSUISymbolTextStyle = NSFont.TextStyle
// }

#elseif canImport(UIKit)

import UIKit

/// extension SFSymbol {
public typealias NSUIImage = UIImage
public typealias NSUIFont = UIFont
public typealias NSUIColor = UIColor
public typealias NSUISymbolConfiguration = UIImage.SymbolConfiguration
public typealias NSUISymbolWeight = UIImage.SymbolWeight
public typealias NSUISymbolScale = UIImage.SymbolScale
public typealias NSUISymbolTextStyle = UIFont.TextStyle
// }
#else

#error("Unsupported Platform")

#endif


public final class SFSymbol {
    public let name: SymbolName

    public private(set) var configuration: NSUISymbolConfiguration?

    public private(set) var variableValue: Double?

    public init(name: SymbolName) {
        self.name = name
    }

    public convenience init(name: SymbolName, pointSize: CGFloat, weight: NSUISymbolWeight) {
        self.init(name: name, pointSize: pointSize, weight: weight, scale: nil)
    }

    public convenience init(name: SymbolName, pointSize: CGFloat, weight: NSUISymbolWeight, scale: NSUISymbolScale?) {
        self.init(name: name)
        if let scale {
            self.configuration = .init(pointSize: pointSize, weight: weight, scale: scale)
        } else {
            self.configuration = .init(pointSize: pointSize, weight: weight)
        }
    }

    public convenience init(name: SymbolName, textStyle: NSUISymbolTextStyle) {
        self.init(name: name, textStyle: textStyle, scale: nil)
    }

    public convenience init(name: SymbolName, scale: NSUISymbolScale) {
        self.init(name: name, textStyle: nil, scale: scale)
    }

    public convenience init(name: SymbolName, textStyle: NSUISymbolTextStyle?, scale: NSUISymbolScale?) {
        self.init(name: name)
        if let textStyle, let scale {
            self.configuration = .init(textStyle: textStyle, scale: scale)
        } else if let textStyle {
            self.configuration = .init(textStyle: textStyle)
        } else if let scale {
            self.configuration = .init(scale: scale)
        }
    }

    public convenience init(systemName: SystemSymbolName) {
        self.init(name: systemName as SymbolName)
    }

    public convenience init(systemName: SystemSymbolName, pointSize: CGFloat, weight: NSUISymbolWeight) {
        self.init(name: systemName, pointSize: pointSize, weight: weight, scale: nil)
    }

    public convenience init(systemName: SystemSymbolName, pointSize: CGFloat, weight: NSUISymbolWeight, scale: NSUISymbolScale?) {
        self.init(name: systemName as SymbolName, pointSize: pointSize, weight: weight, scale: scale)
    }

    public convenience init(systemName: SystemSymbolName, textStyle: NSUISymbolTextStyle) {
        self.init(name: systemName, textStyle: textStyle, scale: nil)
    }

    public convenience init(systemName: SystemSymbolName, scale: NSUISymbolScale) {
        self.init(name: systemName, textStyle: nil, scale: scale)
    }

    public convenience init(systemName: SystemSymbolName, textStyle: NSUISymbolTextStyle?, scale: NSUISymbolScale?) {
        self.init(name: systemName as SymbolName, textStyle: textStyle, scale: scale)
    }

    @available(macOS 12.0, *)
    public func pointSize(_ pointSize: CGFloat, weight: NSUISymbolWeight) -> Self {
        let otherConfiguration = NSUISymbolConfiguration(pointSize: pointSize, weight: weight)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, *)
    public func pointSize(_ pointSize: CGFloat, weight: NSUISymbolWeight, scale: NSUISymbolScale) -> Self {
        let otherConfiguration = NSUISymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, *)
    public func textStyle(_ textStyle: NSUISymbolTextStyle, scale: NSUISymbolScale) -> Self {
        let otherConfiguration = NSUISymbolConfiguration(textStyle: textStyle, scale: scale)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, *)
    public func textStyle(_ textStyle: NSUISymbolTextStyle) -> Self {
        let otherConfiguration = NSUISymbolConfiguration(textStyle: textStyle)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func hierarchicalColor(_ color: NSUIColor) -> Self {
        let otherConfiguration = NSUISymbolConfiguration(hierarchicalColor: color)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func paletteColors(_ colors: [NSUIColor]) -> Self {
        let otherConfiguration = NSUISymbolConfiguration(paletteColors: colors)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, *)
    public func scale(_ scale: NSUISymbolScale) -> Self {
        let otherConfiguration = NSUISymbolConfiguration(scale: scale)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public func variableValue(_ variableValue: Double) -> Self {
        self.variableValue = variableValue
        return self
    }

    public var nsuiImgae: NSUIImage {
        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        return nsImage
        #endif

        #if canImport(UIKit)
        return uiImage
        #endif
    }

    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    public var nsImage: NSImage {
        var image = if let variableValue, #available(macOS 13.0, *) {
            if name is SystemSymbolName {
                NSImage(systemSymbolName: name.rawValue, variableValue: variableValue, accessibilityDescription: nil)
            } else {
                NSImage(symbolName: name.rawValue, bundle: name.bundle, variableValue: variableValue)
            }
        } else {
            if name is SystemSymbolName {
                NSImage(systemSymbolName: name.rawValue, accessibilityDescription: nil)
            } else if let bundle = name.bundle {
                bundle.image(forResource: name.rawValue)
            } else {
                NSImage(named: name.rawValue)
            }
        }

        if let configuration {
            image = image?.withSymbolConfiguration(configuration)
        }

        guard let image else {
            fatalError("Internal Error, check the Name enum for spelling errors")
        }

        return image
    }

    #elseif canImport(UIKit)

    public var uiImage: UIImage {
        let image = if let variableValue, #available(iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
            if name is SystemSymbolName {
                UIImage(systemName: name.rawValue, variableValue: variableValue, configuration: configuration)
            } else {
                UIImage(named: name.rawValue, in: name.bundle, variableValue: variableValue, configuration: configuration)
            }
        } else {
            if name is SystemSymbolName {
                UIImage(systemName: name.rawValue, withConfiguration: configuration)
            } else {
                UIImage(named: name.rawValue, in: name.bundle, with: configuration)
            }
        }

        guard let image else {
            fatalError("Internal Error, check the Name enum for spelling errors")
        }

        return image
    }

    #endif
}

extension NSUIImage {
    public static func symbol(name: SFSymbol.SymbolName) -> NSUIImage {
        SFSymbol(name: name).nsuiImgae
    }

    public static func symbol(name: SFSymbol.SymbolName, pointSize: CGFloat, weight: NSUISymbolWeight) -> NSUIImage {
        SFSymbol(name: name, pointSize: pointSize, weight: weight).nsuiImgae
    }

    public static func symbol(name: SFSymbol.SymbolName, pointSize: CGFloat, weight: NSUISymbolWeight, scale: NSUISymbolScale?) -> NSUIImage {
        SFSymbol(name: name, pointSize: pointSize, weight: weight, scale: scale).nsuiImgae
    }

    public static func symbol(name: SFSymbol.SymbolName, textStyle: NSUISymbolTextStyle) -> NSUIImage {
        SFSymbol(name: name, textStyle: textStyle).nsuiImgae
    }

    public static func symbol(name: SFSymbol.SymbolName, scale: NSUISymbolScale) -> NSUIImage {
        SFSymbol(name: name, scale: scale).nsuiImgae
    }

    public static func symbol(name: SFSymbol.SymbolName, textStyle: NSUISymbolTextStyle?, scale: NSUISymbolScale?) -> NSUIImage {
        SFSymbol(name: name, textStyle: textStyle, scale: scale).nsuiImgae
    }

    public static func symbol(systemName: SFSymbol.SystemSymbolName) -> NSUIImage {
        SFSymbol(systemName: systemName).nsuiImgae
    }

    public static func symbol(systemName: SFSymbol.SystemSymbolName, pointSize: CGFloat, weight: NSUISymbolWeight) -> NSUIImage {
        SFSymbol(systemName: systemName, pointSize: pointSize, weight: weight).nsuiImgae
    }

    public static func symbol(systemName: SFSymbol.SystemSymbolName, pointSize: CGFloat, weight: NSUISymbolWeight, scale: NSUISymbolScale?) -> NSUIImage {
        SFSymbol(systemName: systemName, pointSize: pointSize, weight: weight, scale: scale).nsuiImgae
    }

    public static func symbol(systemName: SFSymbol.SystemSymbolName, textStyle: NSUISymbolTextStyle) -> NSUIImage {
        SFSymbol(systemName: systemName, textStyle: textStyle).nsuiImgae
    }

    public static func symbol(systemName: SFSymbol.SystemSymbolName, scale: NSUISymbolScale) -> NSUIImage {
        SFSymbol(systemName: systemName, scale: scale).nsuiImgae
    }

    public static func symbol(systemName: SFSymbol.SystemSymbolName, textStyle: NSUISymbolTextStyle?, scale: NSUISymbolScale?) -> NSUIImage {
        SFSymbol(systemName: systemName, textStyle: textStyle, scale: scale).nsuiImgae
    }
}
