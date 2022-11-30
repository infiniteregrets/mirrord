package com.metalbear.mirrord

import com.beust.klaxon.Klaxon
import com.intellij.execution.ExecutionListener
import com.intellij.execution.runners.ExecutionEnvironment
import com.intellij.openapi.application.ApplicationManager
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonObject
import java.nio.file.Paths



class MirrordListener : ExecutionListener {

    private val defaults = MirrordDefaultConfig()

    init {
        mirrordEnv["DYLD_INSERT_LIBRARIES"] = defaults.dylibPath
        mirrordEnv["LD_PRELOAD"] = defaults.ldPreloadPath
        mirrordEnv["DEBUGGER_IGNORE_PORTS_PATCH"] = defaults.ignorePorts
    }

    companion object {
        var id: String = ""
        var enabled: Boolean = false
            set(value) {
                id = ""
                field = value
            }
        var envSet: Boolean = false

        // defaultFlow: keeps track of whether we are doing the mirrord config or not
        var defaultFlow: Boolean = false
        var mirrordEnv: LinkedHashMap<String, String> = LinkedHashMap()
    }

    override fun processStartScheduled(executorId: String, env: ExecutionEnvironment) {
        if (enabled && id.isEmpty()) {
            id = executorId // id is set here to make sure we don't spawn the dialog twice
            ApplicationManager.getApplication().invokeLater {
                val workspace = env.project.basePath!!
                val mirrordDir = Paths.get(workspace, ".mirrord").toFile()
                if (!mirrordDir.exists() || !mirrordDir.isDirectory) {
                    mirrordDir.mkdir()
                }
                val mirrordConfig =
                    mirrordDir.listFiles()?.find { it.name.matches(Regex(".*\\.mirrord\\.(toml|json|y?(a)ml)")) }.run {
                        val mirrordConfig = Paths.get(workspace, ".mirrord/mirrord.json").toFile()
                        mirrordConfig.createNewFile()
                        mirrordConfig.writeText(defaults.defaultConfig)
                        mirrordConfig
                    }

                val mirrordConfigJson = mirrordConfig.readText()

                val json: Map<String, JsonElement> = Json.parseToJsonElement(mirrordConfigJson).jsonObject

//                mirrordConfigObj?.target?.path?.let {
//                    // TODO:
//                }
                envSet = true

            }
        }
    }
}