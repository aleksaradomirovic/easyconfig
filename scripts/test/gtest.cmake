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

function(easyconfig_add_gtest FN_TARGET_NAME)
    if(NOT EASYCONFIG_BUILD_TESTING)
        return()
    endif()

    easyconfig_init_main_test()

    cmake_parse_arguments(
        PARSE_ARGV 1
        FN
        ""
        "TEST_NAME;PARENT"
        "SOURCES"
    )
    list(APPEND FN_SOURCES ${FN_UNPARSED_ARGUMENTS})
    easyconfig_arg_define(FN_SOURCES)

    easyconfig_arg_define(FN_TEST_NAME)

    if(DEFINED FN_SOURCES)
        if(NOT DEFINED FN_TEST_NAME)
            set(FN_TEST_NAME "${FN_TARGET_NAME}_test")
        endif()

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
            COMMAND "$<TARGET_FILE:${FN_TARGET_NAME}>"
        )
        add_dependencies("${FN_TEST_NAME}" "${FN_TARGET_NAME}")
    else()
        if(NOT DEFINED FN_TEST_NAME)
            set(FN_TEST_NAME "${FN_TARGET_NAME}")
        endif()

        add_custom_target("${FN_TEST_NAME}")
    endif()

    easyconfig_arg_define(FN_PARENT)
    if(DEFINED FN_PARENT)
        if(NOT TARGET "${FN_PARENT}")
            add_dependencies("${FN_PARENT}_test" "${FN_TEST_NAME}")
        else()
            add_dependencies("${FN_PARENT}" "${FN_TEST_NAME}")
        endif()
    else()
        add_dependencies("test" "${FN_TEST_NAME}")
    endif()
endfunction()
