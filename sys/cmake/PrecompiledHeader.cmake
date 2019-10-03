function(export_all_flags _filename)
    set(_include_directories "$<TARGET_PROPERTY:${_target},INCLUDE_DIRECTORIES>")
    set(_compile_definitions "$<TARGET_PROPERTY:${_target},COMPILE_DEFINITIONS>")
    string(TOUPPER "CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE}" _current_build_compile_flags)
    set(_compile_flags "$<TARGET_PROPERTY:${_target},COMPILE_FLAGS>" "${CMAKE_CXX_FLAGS}" "${${_current_build_compile_flags}}")
    set(_compile_options "$<TARGET_PROPERTY:${_target},COMPILE_OPTIONS>")
    set(_include_directories "$<$<BOOL:${_include_directories}>:-I$<JOIN:${_include_directories},\n-I>\n>")
    set(_compile_definitions "$<$<BOOL:${_compile_definitions}>:-D$<JOIN:${_compile_definitions},\n-D>\n>")
    set(_compile_flags "$<$<BOOL:${_compile_flags}>:$<JOIN:${_compile_flags},\n>\n>")
    set(_compile_options "$<$<BOOL:${_compile_options}>:$<JOIN:${_compile_options},\n>\n>")
    file(GENERATE OUTPUT "${_filename}" CONTENT "${_compile_definitions}${_include_directories}${_compile_flags}${_compile_options}\n")
endfunction()

MACRO(ADD_MSVC_PRECOMPILED_HEADER PrecompiledHeader PrecompiledSource SourcesVar)
    GET_FILENAME_COMPONENT(PrecompiledBasename ${PrecompiledHeader} NAME_WE)
    SET(PrecompiledBinary "${CMAKE_CFG_INTDIR}/${PrecompiledBasename}.pch")
    SET(Sources ${${SourcesVar}})
    # precompiled headers for C/C++ sources are different, so don't apply to .c files
    LIST(FILTER Sources EXCLUDE REGEX "\\.c$")

    IF(MSVC)
        MESSAGE("Setting up precompiled header for MSVC")
        SET_SOURCE_FILES_PROPERTIES(${PrecompiledSource}
                PROPERTIES COMPILE_FLAGS "/Yc\"${PrecompiledHeader}\" /Fp\"${PrecompiledBinary}\""
                OBJECT_OUTPUTS "${PrecompiledBinary}")
        SET_SOURCE_FILES_PROPERTIES(${Sources}
                PROPERTIES COMPILE_FLAGS "/Yu\"${PrecompiledHeader}\" /FI\"${PrecompiledHeader}\" /Fp\"${PrecompiledBinary}\""
                OBJECT_DEPENDS "${PrecompiledBinary}")
        # Add precompiled header to SourcesVar
        LIST(APPEND ${SourcesVar} ${PrecompiledSource})
    ENDIF()

    IF(CMAKE_COMPILER_IS_GNUCXX)
        MESSAGE("Setting up precompiled header for GCC")
        set(PrecompiledOutputDir "${CMAKE_CURRENT_BINARY_DIR}/pch")
        set(CopiedPch "${PrecompiledOutputDir}/${PrecompiledHeader}")
        get_filename_component(BaseName ${PrecompiledHeader} NAME)
        set(CompiledPch "${PrecompiledOutputDir}/${BaseName}.gch")
        set(_target TheDarkMod)
        set(PchFlagsFile "${PrecompiledOutputDir}/compile_flags.rsp")
        export_all_flags("${PchFlagsFile}")
        set(_compiler_FLAGS "@${PchFlagsFile}")

        add_custom_command(OUTPUT "${CopiedPch}"
                COMMAND "${CMAKE_COMMAND}" -E copy "${CMAKE_CURRENT_SOURCE_DIR}/idlib/${PrecompiledHeader}" "${CopiedPch}"
                DEPENDS "idlib/${PrecompiledHeader}"
                COMMENT "Updating precompiled header")
        add_custom_command(OUTPUT "${CompiledPch}"
                COMMAND "${CMAKE_CXX_COMPILER}" ${_compiler_FLAGS} -x c++-header -o "${CompiledPch}" "${CopiedPch}"
                DEPENDS "${CopiedPch}" "${PchFlagsFile}"
                COMMENT "Precompiling header")

        SET_SOURCE_FILES_PROPERTIES(${Sources}
                PROPERTIES COMPILE_FLAGS "-include \"${CopiedPch}\" -Winvalid-pch"
                OBJECT_DEPENDS "${CompiledPch}")
    ENDIF()
ENDMACRO(ADD_MSVC_PRECOMPILED_HEADER)
