//
//  main.swift
//  MURE
//
//  Created by Kota on 2/26/R7.
//
import PackagePlugin
@main
struct KernelsCompilePlugin: BuildToolPlugin {
	func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
		guard let target = target as?SourceModuleTarget else { return.init() }
		let sources = target.sourceFiles(withSuffix: "ci.metal").map(\.url)
		guard !sources.isEmpty else { return.init() }
		let intermediates = context.pluginWorkDirectoryURL
		let output = intermediates.appending(component: "ci").appendingPathExtension("metallib")
		return [
			.buildCommand(
				displayName: "xcrun",
				executable: .init(filePath: "/usr/bin/xcrun"),
				arguments: [
					"metal",
					"-fmodules-cache-path=\(intermediates.path())",
					"-fcikernel",
					"-o",
					output.path(),
				] + sources.map { $0.path() },
				environment: [:],
				inputFiles: sources,
				outputFiles: [output])
		]
	}
}
