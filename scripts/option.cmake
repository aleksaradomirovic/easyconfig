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

function(easyconfig_arg_define FNFN_ARGVAR)
    if(NOT DEFINED "${FNFN_ARGVAR}")
        return()
    endif()

    string(STRIP "${${FNFN_ARGVAR}}" "${FNFN_ARGVAR}")
    if("${${FNFN_ARGVAR}}" STREQUAL "")
        unset("${FNFN_ARGVAR}")
        unset("${FNFN_ARGVAR}" CACHE)
    endif()

    return(PROPAGATE "${FNFN_ARGVAR}")
endfunction()

function(easyconfig_pop_arg FNFN_ARGVAR)
    easyconfig_arg_define("${FNFN_ARGVAR}")
    if(DEFINED "${FNFN_ARGVAR}")
        return()
    endif()

    cmake_parse_arguments(
        PARSE_ARGV 1
        FNFN
        ""
        ""
        ""
    )

    list(LENGTH FN_UNPARSED_ARGUMENTS FNFN_LISTLEN)
    list(LENGTH FNFN_UNPARSED_ARGUMENTS FNFN_DEFAULT)
    if(FNFN_LISTLEN GREATER "0")
        list(POP_FRONT FN_UNPARSED_ARGUMENTS "${FNFN_ARGVAR}")
    elseif(FNFN_DEFAULT GREATER "0")
        set("${FNFN_ARGVAR}" "${FNFN_UNPARSED_ARGUMENTS}")
    else()
        unset("${FNFN_ARGVAR}")
    endif()

    return(PROPAGATE FN_UNPARSED_ARGUMENTS "${FNFN_ARGVAR}")
endfunction()

function(easyconfig_option FN_NAME)
    cmake_parse_arguments(
        PARSE_ARGV 1
        FN
        "ALLOW_UNSET"
        "DEFAULT;TYPE;DOC"
        ""
    )
    easyconfig_pop_arg(FN_DEFAULT)
    if(NOT DEFINED FN_DEFAULT AND NOT ALLOW_UNSET)
        message(FATAL_ERROR "Option ${FN_NAME} requires a value")
    endif()
    easyconfig_pop_arg(FN_TYPE "STRING")
    easyconfig_pop_arg(FN_DOC "${FN_DEFAULT}")

    if(NOT DEFINED "${FN_NAME}")
        set("${FN_NAME}" "${FN_DEFAULT}")
        set("${FN_NAME}" "${${FN_NAME}}" CACHE "${FN_TYPE}" "${FN_DOC}" FORCE)
    endif()

    message(DEBUG "Set option ${FN_NAME} to '${${FN_NAME}}'")
endfunction()
