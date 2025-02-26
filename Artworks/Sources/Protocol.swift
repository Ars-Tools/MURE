//
//  Artwork.swift
//  MURE
//
//  Created by Kota on 2/25/R7.
//
@preconcurrency import CoreGraphics
@preconcurrency import Metal
public protocol Artwork {
	func callAsFunction(
		colorspace: Optional<CGColorSpace>,
		pixelFormat: MTLPixelFormat,
		mtlCommandQueue: MTLCommandQueue
	) throws -> (CFTimeInterval, MTLTexture, MTLCommandBuffer) -> Void
}
