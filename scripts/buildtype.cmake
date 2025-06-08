# Copyright 2025 Aleksa Radomirovic
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function(easyconfig_configure_build_type)
    cmake_parse_arguments(
        PARSE_ARGV 0
        FN
        ""
        "DEFAULT"
        "BUILD_TYPES"
    )
    list(APPEND FN_BUILD_TYPES ${FN_UNPARSED_ARGUMENTS})
    string(STRIP "${FN_BUILD_TYPES}" FN_BUILD_TYPES)

    if(FN_BUILD_TYPES STREQUAL "")
        list(APPEND FN_BUILD_TYPES "Release;Debug;RelWithDebInfo;MinSizeRel")
    endif()
    message(DEBUG "Permitted build types: ${FN_BUILD_TYPES}")

    if(NOT DEFINED FN_DEFAULT)
        list(GET FN_BUILD_TYPES 0 FN_DEFAULT)
    elseif(NOT FN_DEFAULT IN_LIST FN_BUILD_TYPES)
        message(SEND_ERROR "Default build type '${FN_DEFAULT}' was not specified as permitted: ${FN_BUILD_TYPES}")
    endif()
    message(DEBUG "Default build type: ${FN_DEFAULT}")

    if(NOT DEFINED CMAKE_BUILD_TYPE OR CMAKE_BUILD_TYPE STREQUAL "")
        set(CMAKE_BUILD_TYPE "${FN_DEFAULT}" CACHE STRING "CMake build type" FORCE)

        message(WARNING "Build type not specified [CMAKE_BUILD_TYPE]; defaulting to '${CMAKE_BUILD_TYPE}'")
    elseif(NOT CMAKE_BUILD_TYPE IN_LIST FN_BUILD_TYPES)
        message(FATAL_ERROR "Specified build type '${CMAKE_BUILD_TYPE}' is not permitted: ${FN_BUILD_TYPES}")
    endif()

    if(NOT CMAKE_BUILD_TYPE STREQUAL "$CACHE{EASYCONFIG_BUILD_TYPE}")
        set(EASYCONFIG_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING "CMake build type" FORCE)
        message(STATUS "Project build type: ${CMAKE_BUILD_TYPE}")
    endif()
endfunction()

function(easyconfig_configure_build_shared_libs)
    cmake_parse_arguments(
        PARSE_ARGV 0
        FN
        "WARN"
        "DEFAULT"
        ""
    )
    easyconfig_pop_arg(FN_DEFAULT "ON")

    if(NOT DEFINED BUILD_SHARED_LIBS)
        set(BUILD_SHARED_LIBS "${FN_DEFAULT}" CACHE BOOL "Build shared libraries" FORCE)

        if(FN_WARN)
            message(WARNING "Building of shared libraries not specified [BUILD_SHARED_LIBS]; defaulting to '${BUILD_SHARED_LIBS}'")
        endif()
    endif()

    message(DEBUG "Building shared libs: ${BUILD_SHARED_LIBS}")
endfunction()
