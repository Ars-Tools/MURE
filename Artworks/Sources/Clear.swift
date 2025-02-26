//
//  Clear.swift
//  MURE
//
//  Created by Kota on 2/25/R7.
//
@preconcurrency import CoreGraphics
@preconcurrency import Metal
@preconcurrency import os.log
extension MTLClearColor: Artwork {
	public func callAsFunction(colorspace: Optional<CGColorSpace>,
							   pixelFormat: MTLPixelFormat,
							   mtlCommandQueue: MTLCommandQueue) throws -> (CFTimeInterval, MTLTexture, MTLCommandBuffer) -> Void {
		{
			let descriptor = MTLRenderPassDescriptor()
			descriptor.colorAttachments[0].texture = $1
			descriptor.colorAttachments[0].storeAction = .store
			descriptor.colorAttachments[0].loadAction = .clear
			descriptor.colorAttachments[0].clearColor = self
			$2.makeRenderCommandEncoder(descriptor: descriptor)?.endEncoding()
		}
	}
}
