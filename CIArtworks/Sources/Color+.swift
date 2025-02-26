//
//  Color+.swift
//  MURE
//
//  Created by Kota on 2/25/R7.
//
@preconcurrency import CoreImage
@preconcurrency import Metal
@preconcurrency import os.log
extension CIColor: CIArtwork {
	public var outputImage: Optional<CIImage> {
		.some(CIImage(color: self))
	}
}
