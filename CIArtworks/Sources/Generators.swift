//
//  QR.swift
//  MURE
//
//  Created by Kota on 2/25/R7.
//
@preconcurrency import CoreImage.CIFilterBuiltins
@preconcurrency import protocol Combine.Publisher
public func noise() -> some CIArtwork {
	CIFilter.randomGenerator() as CIFilter
}
public func qr(message: Data) -> some CIArtwork {
	let filter = CIFilter.qrCodeGenerator()
	filter.message = message
	filter.correctionLevel = "Q"
	return filter as CIFilter
}
