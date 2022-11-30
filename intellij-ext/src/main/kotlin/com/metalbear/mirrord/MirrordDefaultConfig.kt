package com.metalbear.mirrord

import com.intellij.openapi.application.PathManager
import java.nio.file.Paths

data class MirrordDefaultConfig(
    val ldPreloadPath: String = getSharedLibPath("libmirrord_layer.so"),
    val dylibPath: String = getSharedLibPath("libmirrord_layer.dylib"),
    val telemetry: Boolean = true,
    val ignorePorts: String = "45000-65535",
) {
    val defaultConfig: String = """
    {
        "accept_invalid_certificates": false,
        "feature": {
            "network": {
                "incoming": "mirror",
                "outgoing": true
            },
            "fs": "read",
            "env": true
        }
    }
""".trimIndent()
}

private fun getSharedLibPath(libName: String): String {
    val path = Paths.get(PathManager.getPluginsPath(), "mirrord", libName).toString()

    if (System.getProperty("os.name").toLowerCase().contains("win")) {
        val wslRegex = "^[a-zA-Z]:".toRegex()

        val wslPath = wslRegex.replace(path) { drive ->
            "/mnt/" + drive.value.toLowerCase().removeSuffix(":")
        }

        return wslPath.replace("\\", "/")
    }

    return path
}
