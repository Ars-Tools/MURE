// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "MURE",
	platforms: [
		.iOS(.v18),
		.tvOS(.v18),
		.macCatalyst(.v18),
		.macOS(.v15),
	],
    products: [
        .library(
            name: "Graphics",
            targets: [
				"Artworks",
				"CIArtworks",
			]
		)
    ],
	dependencies: [
		.package(url: "https://github.com/Ars-Tools/fcikernel", branch: "develop"),
	],
    targets: [
		.target(
			name: "Artworks",
			path: "Artworks/Sources"
		),
		.target(
			name: "CIArtworks",
			dependencies: [
				"Artworks"
			],
			path: "CIArtworks/Sources",
			plugins: [
				.plugin(name: "fcikernel", package: "fcikernel")
			]
		)
    ]
)
