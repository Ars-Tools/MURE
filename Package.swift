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
//		.executable(
//			name: "Snippets",
//			targets: ["Snippets"]
//		),
        .library(
            name: "Graphics",
            targets: [
				"Artworks",
				"CIArtworks",
			]),
    ],
    targets: [
		.executableTarget(
			name: "Snippets",
			dependencies: [
				.targetItem(name: "Artworks", condition: .none),
				.targetItem(name: "CIArtworks", condition: .none),
//				.productItem(name: "Graphics", package: .none, moduleAliases: .none, condition: .none)
			],
			path: "Snippets/Sources"
		),
		.target(
			name: "Artworks",
			path: "Artworks/Sources"
		),
		.target(
			name: "CIArtworks",
			dependencies: ["Artworks"],
			path: "CIArtworks/Sources"
		)
    ]
)
