//
//  Protocol.swift
//  MURE
//
//  Created by Kota on 2/25/R7.
//
@preconcurrency import CoreImage
@preconcurrency import Artworks
@preconcurrency import os.log
private let log = OSLog(subsystem: #file, category: .dynamicTracing)
private enum Error: Swift.Error {
	case noOutputImageFound
}
public protocol CIArtwork: Artwork {
	var outputImage: Optional<CIImage> { get }
}
extension CIArtwork {
	public func callAsFunction(colorspace: Optional<CGColorSpace>, pixelFormat: MTLPixelFormat, mtlCommandQueue: MTLCommandQueue) throws -> (CFTimeInterval, MTLTexture, MTLCommandBuffer) -> Void {
		let ciContext = CIContext(mtlCommandQueue: mtlCommandQueue, options: [
			.outputColorSpace: colorspace as Any
		])
		return {
			do {
				switch outputImage {
				case.some(let image):
					try ciContext.startTask(toRender: image, to: .init(mtlTexture: $1, commandBuffer: $2))
				case.none:
					throw Error.noOutputImageFound
				}
			} catch {
				print(error)
				os_log(.error, log: log, "%{public}@", error.localizedDescription)
			}
		}
	}
}
extension CIFilter: CIArtwork {}
extension CIImage: CIArtwork {
	public var outputImage: Optional<CIImage> { .some(self) }
}
