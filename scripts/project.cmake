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

function(easyconfig_project)
    cmake_parse_arguments(
        PARSE_ARGV 0
        FN
        "WARN"
        "DEFAULT_BUILD_TYPE;BUILD_SHARED_LIBS"
        "BUILD_TYPES"
    )
    if(FN_WARN)
        set(FN_WARN_ARG "WARN")
    else()
        unset(FN_WARN_ARG)
    endif()

    message(DEBUG "Configuring project '${PROJECT_NAME}'")

    easyconfig_configure_build_type(DEFAULT ${FN_DEFAULT_BUILD_TYPE} BUILD_TYPES ${FN_BUILD_TYPES})
    easyconfig_configure_build_shared_libs(DEFAULT ${FN_BUILD_SHARED_LIBS} ${FN_WARN_ARG})

    easyconfig_option(EASYCONFIG_BUILD_TESTING ON BOOL "Build easyconfig tests")
endfunction()
