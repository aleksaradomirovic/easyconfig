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

function(easytest_add_gtest FN_TARGET_NAME)
    if(NOT EASYCONFIG_BUILD_TESTING)
        return()
    endif()

    cmake_parse_arguments(
        PARSE_ARGV 1
        FN
        ""
        "CATEGORY"
        "SOURCES"
    )
    list(APPEND FN_SOURCES ${FN_UNPARSED_ARGUMENTS})
    easyconfig_arg_define(FN_SOURCES)

    set(FN_TEST_NAME "${FN_TARGET_NAME}${EASYTEST_RUN_TARGET_SUFFIX}")

    add_executable(
        "${FN_TARGET_NAME}"
        EXCLUDE_FROM_ALL
            ${FN_SOURCES}
    )
    target_link_libraries(
        "${FN_TARGET_NAME}"
        PRIVATE
            GTest::gtest
            GTest::gtest_main
    )
    
    add_custom_target(
        "${FN_TEST_NAME}"
        COMMAND $<TARGET_FILE:${FN_TARGET_NAME}>
    )
    add_dependencies("${FN_TEST_NAME}" "${FN_TARGET_NAME}")

    easytest_set_test_category("${FN_TEST_NAME}" "${FN_CATEGORY}")
endfunction()
