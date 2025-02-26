//
//  Environment+.swift
//  MURE
//
//  Created by Kota on 2/25/R7.
//
@preconcurrency import struct SwiftUI.EnvironmentValues
@preconcurrency import protocol SwiftUI.EnvironmentKey
@preconcurrency import func Metal.MTLCreateSystemDefaultDevice
@preconcurrency import protocol Metal.MTLDevice
@preconcurrency import protocol Metal.MTLCommandQueue
@preconcurrency import class CoreGraphics.CGColorSpace
@preconcurrency import func CoreGraphics.CGColorSpaceCreateDeviceRGB
public enum CGColorSpaceKey: EnvironmentKey {
	public static let defaultValue: CGColorSpace = CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
}
public enum MTLDeviceKey: EnvironmentKey {
	public static let defaultValue: Optional<MTLDevice> = MTLCreateSystemDefaultDevice()
}
public enum MTLCommandQueueKey: EnvironmentKey {
	public static let defaultValue: Optional<MTLCommandQueue> = MTLDeviceKey.defaultValue.flatMap { $0.makeCommandQueue() }
}
extension EnvironmentValues {
	public var cgColorSpace: CGColorSpace {
		_read {
			yield self[CGColorSpaceKey.self]
		}
//		_modify {
//			yield &self[CGColorSpaceKey.self]
//		}
	}
	public var mtlDevice: Optional<MTLDevice> {
		_read {
			yield self[MTLDeviceKey.self]
		}
//		_modify {
//			yield &self[MTLDeviceKey.self]
//		}
	}
	public var mtlCommandQueue: Optional<MTLCommandQueue> {
		_read {
			yield self[MTLCommandQueueKey.self]
		}
//		_modify {
//			yield &self[MTLCommandQueueKey.self]
//		}
	}
}
