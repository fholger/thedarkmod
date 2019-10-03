macro(get_svn_revision OutVar)
    message("Determining SVN revision")
    find_program(SVNVERSION_PROGRAM name svnversion)
    if (SVNVERSION_PROGRAM)
        execute_process(COMMAND "${SVNVERSION_PROGRAM}" "-c"
                WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
                RESULT_VARIABLE SVNVERSION_SUCCESS
                OUTPUT_VARIABLE ${OutVar})
        if (NOT SVNVERSION_SUCCESS)
            message("svnversion failed")
            set(${OutVar} "NOTFOUND")
        endif()
    else()
        message("svnversion not found")
        set(${OutVar} "NOTFOUND")
    endif()
endmacro()
