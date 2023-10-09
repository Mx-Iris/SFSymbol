#if canImport(AppKit) && !targetEnvironment(macCatalyst)

    import AppKit

    extension SFSymbol {
        public typealias CocoaImage = NSImage
        public typealias CocoaFont = NSFont
        public typealias CocoaColor = NSColor
        public typealias SymbolConfiguration = NSImage.SymbolConfiguration
        public typealias SymbolWeight = NSFont.Weight
        public typealias SymbolScale = NSImage.SymbolScale
        public typealias SymbolTextStyle = NSFont.TextStyle
    }

#elseif canImport(UIKit)

    import UIKit

    extension SFSymbol {
        public typealias CocoaImage = UIImage
        public typealias CocoaFont = UIFont
        public typealias CocoaColor = UIColor
        public typealias SymbolConfiguration = UIImage.SymbolConfiguration
        public typealias SymbolWeight = UIImage.SymbolWeight
        public typealias SymbolScale = UIImage.SymbolScale
        public typealias SymbolTextStyle = UIFont.TextStyle
    }
#else

    #error("Unsupported Platform")

#endif

import SwiftUI

public final class SFSymbol {
    public let name: Name

    public private(set) var configuration: SymbolConfiguration?

    public private(set) var variableValue: Double?

    public init(name: Name) {
        self.name = name
    }

    public init(name: Name, pointSize: CGFloat, weight: SymbolWeight) {
        self.name = name
        self.configuration = .init(pointSize: pointSize, weight: weight)
    }

    public init(name: Name, pointSize: CGFloat, weight: SymbolWeight, scale: SymbolScale) {
        self.name = name
        self.configuration = .init(pointSize: pointSize, weight: weight, scale: scale)
    }

    public init(name: Name, textStyle: SymbolTextStyle) {
        self.name = name
        self.configuration = .init(textStyle: textStyle)
    }

    public init(name: Name, textStyle: SymbolTextStyle, scale: SymbolScale) {
        self.name = name
        self.configuration = .init(textStyle: textStyle, scale: scale)
    }

    public init(name: Name, scale: SymbolScale) {
        self.name = name
        self.configuration = .init(scale: scale)
    }

    @available(macOS 12.0, *)
    public func pointSize(_ pointSize: CGFloat, weight: SymbolWeight) -> Self {
        let otherConfiguration = SymbolConfiguration(pointSize: pointSize, weight: weight)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, *)
    public func pointSize(_ pointSize: CGFloat, weight: SymbolWeight, scale: SymbolScale) -> Self {
        let otherConfiguration = SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, *)
    public func textStyle(_ textStyle: SymbolTextStyle, scale: SymbolScale) -> Self {
        let otherConfiguration = SymbolConfiguration(textStyle: textStyle, scale: scale)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, *)
    public func textStyle(_ textStyle: SymbolTextStyle) -> Self {
        let otherConfiguration = SymbolConfiguration(textStyle: textStyle)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0,  *)
    public func hierarchicalColor(_ color: CocoaColor) -> Self {
        let otherConfiguration = SymbolConfiguration(hierarchicalColor: color)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0,  *)
    public func paletteColors(_ colors: [CocoaColor]) -> Self {
        let otherConfiguration = SymbolConfiguration(paletteColors: colors)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 12.0, *)
    public func scale(_ scale: SymbolScale) -> Self {
        let otherConfiguration = SymbolConfiguration(scale: scale)
        configuration = configuration.map { $0.applying(otherConfiguration) } ?? otherConfiguration
        return self
    }

    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public func variableValue(_ variableValue: Double) -> Self {
        self.variableValue = variableValue
        return self
    }

    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        public var nsImage: NSImage {
            var image = if let variableValue, #available(macOS 13.0, *) {
                NSImage(systemSymbolName: name.rawValue, variableValue: variableValue, accessibilityDescription: nil)
            } else {
                NSImage(systemSymbolName: name.rawValue, accessibilityDescription: nil)
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
                UIImage(systemName: name.rawValue, variableValue: variableValue, configuration: configuration)
            } else {
                UIImage(systemName: name.rawValue, withConfiguration: configuration)
            }
            
            guard let image else {
                fatalError("Internal Error, check the Name enum for spelling errors")
            }
            
            return image
        }

    #endif
    
    public var image: SwiftUI.Image {
        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        return .init(nsImage: nsImage)
        #elseif canImport(UIKit)
        return .init(uiImage: uiImage)
        #else
        #error("Unsupported Platform")
        #endif
    }
    
}
