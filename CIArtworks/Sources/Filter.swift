//
//  Filter.swift
//  MURE
//
//  Created by Kota on 2/26/R7.
//
@preconcurrency import CoreImage
final class ThreeDyeFilter: CIFilter {
	private let kernel: CIColorKernel

	   var inputImage: CIImage?

	   override init() {
		   let url = Bundle.module.url(forResource: "ci", withExtension: "metallib")!
		   let data = try! Data(contentsOf: url)
		   kernel = try! CIColorKernel(functionName: "myColor", fromMetalLibraryData: data)
		   super.init()
	   }
	   
	   required init?(coder aDecoder: NSCoder) {
		   fatalError("init(coder:) has not been implemented")
	   }

	   func outputImage() -> CIImage? {
		   print(inputImage)
		   guard let inputImage else {return nil}
		   print(inputImage)
		   return kernel.apply(extent: inputImage.extent, arguments: [inputImage])
	   }
}
nonisolated(unsafe) let n = CIFilter.randomGenerator()
public func testCustomFilter() -> some CIArtwork {
	
		let url = Bundle.module.url(forResource: "ci", withExtension: "metallib")!
		let data = try! Data(contentsOf: url)
		let kernel = try! CIColorKernel(functionName: "myColor", fromMetalLibraryData: data)
	let source = CIFilter.randomGenerator().outputImage.unsafelyUnwrapped
	return kernel.apply(extent: source.extent, arguments: [
		source,
		CIVector(x: 0.5, y: 0.5)
	]).flatMap(\.outputImage).unsafelyUnwrapped
}
