# MIT License
#
# Copyright (c) 2025 Aleksa Radomirovic
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set(BOOLEAN_OPTIONS_ALLOWED 1;ON;YES;TRUE;Y;0;OFF;NO;FALSE;N)

function(auto_configure_option _OPTION)
    cmake_parse_arguments(
        PARSE_ARGV 1
        ""
        "REQUIRED;SILENT"
        "DEFAULT;TYPE;DOC"
        "ALLOWED"
    )

    if(NOT _TYPE)
        set(_TYPE "STRING")
    endif()

    if(NOT DEFINED _DOC)
        set(_DOC "Config option '${_OPTION}'")
    endif()

    if(NOT DEFINED ${_OPTION})
        if(DEFINED _DEFAULT)
            set(_VALUE "${_DEFAULT}")

            if(NOT _SILENT)
                message(WARNING "${_DOC} not specified, defaulting to: '${_VALUE}'")
            endif()
        elseif(_REQUIRED)
            message(FATAL_ERROR "Option '${_OPTION}' not provided")
        endif()
    else()
        set(_VALUE "${${_OPTION}}")
    endif()

    if((DEFINED _ALLOWED) AND (NOT "${_VALUE}" IN_LIST _ALLOWED))
        message(FATAL_ERROR "Illegal option value for '${_OPTION}': '${_VALUE}'; allowed: ${_ALLOWED}")
    endif()
    
    set("${_OPTION}" "${_VALUE}" CACHE "${_TYPE}" "${_DOC}" FORCE)
endfunction()

function(auto_configure_project)
    cmake_parse_arguments(
        PARSE_ARGV 0
        ""
        "DEFAULT_BUILD_TYPE;BUILD_SHARED_LIBS"
        "BUILD_TYPES"
        ""
    )

    list(APPEND _BUILD_TYPES Release Debug RelWithDebInfo MinSizeRel)
    if(NOT _DEFAULT_BUILD_TYPE)
        list(GET _BUILD_TYPES 0 _DEFAULT_BUILD_TYPE)
    endif()
    auto_configure_option(CMAKE_BUILD_TYPE DOC "Build type" DEFAULT "${_DEFAULT_BUILD_TYPE}" ALLOWED ${_BUILD_TYPES})

    if(NOT _BUILD_SHARED_LIBS)
        set(_BUILD_SHARED_LIBS "ON")
    endif()
    auto_configure_option(BUILD_SHARED_LIBS DOC "Building shared libraries" DEFAULT "${_BUILD_SHARED_LIBS}" ALLOWED ${BOOLEAN_OPTIONS_ALLOWED})
endfunction()


