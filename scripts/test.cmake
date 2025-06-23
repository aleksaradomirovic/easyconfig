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

define_property(
    DIRECTORY
    PROPERTY EASYTEST_CATEGORY
    INHERITED
)

define_property(
    TARGET
    PROPERTY EASYTEST_CATEGORY
)

define_property(
    DIRECTORY
    PROPERTY EASYTEST_CATEGORY_LOCAL
)

function(easytest_add_category FN_TARGET_NAME)
    cmake_parse_arguments(
        PARSE_ARGV 1
        FN
        "SET"
        ""
        ""
    )
    easyconfig_pop_arg(FN_PARENT_TARGET_NAME)

    message(DEBUG "Adding test category: ${FN_TARGET_NAME}")
    add_custom_target("${FN_TARGET_NAME}")

    if(NOT DEFINED FN_PARENT_TARGET_NAME)
        get_property(
            FN_PARENT_TARGET_NAME
            DIRECTORY
            PROPERTY EASYTEST_CATEGORY
        )
    endif()

    if(DEFINED FN_PARENT_TARGET_NAME)
        easytest_set_test_category("${FN_TARGET_NAME}" "${FN_PARENT_TARGET_NAME}")
    endif()

    if(FN_SET)
        easytest_set_directory_category("${FN_TARGET_NAME}")
    endif()
endfunction()

function(easytest_set_directory_category FN_CATEGORY)
    message(DEBUG "Setting test category of ${CMAKE_CURRENT_SOURCE_DIR}: ${FN_CATEGORY}")

    get_property(
        FN_CATEGORY_LOCAL
        DIRECTORY
        PROPERTY EASYTEST_CATEGORY_LOCAL
    )
    if(DEFINED FN_CATEGORY_LOCAL)
        message(AUTHOR_WARNING "Directory already has an easytest category defined: ${FN_CATEGORY_LOCAL}")
    endif()

    set_property(
        DIRECTORY
        PROPERTY EASYTEST_CATEGORY "${FN_CATEGORY}"
    )
    set_property(
        DIRECTORY
        PROPERTY EASYTEST_CATEGORY_LOCAL "${FN_CATEGORY}"
    )
endfunction()

function(easytest_set_test_category FN_TEST_NAME)
    cmake_parse_arguments(
        PARSE_ARGV 1
        FN
        ""
        ""
        ""
    )
    easyconfig_pop_arg(FN_CATEGORY)
    if(NOT DEFINED FN_CATEGORY)
        get_property(
            FN_CATEGORY
            DIRECTORY
            PROPERTY EASYTEST_CATEGORY
        )
    endif()

    message(DEBUG "Setting test category of ${FN_TEST_NAME}: ${FN_CATEGORY}")

    get_property(
        FN_TEST_CATEGORY
        TARGET "${FN_TEST_NAME}"
        PROPERTY EASYTEST_CATEGORY
    )
    if(DEFINED FN_TEST_CATEGORY)
        message(SEND_ERROR "Test ${FN_TEST_NAME} already has a category defined")
        return()
    endif()

    add_dependencies("${FN_CATEGORY}" "${FN_TEST_NAME}")
    set_property(
        TARGET "${FN_TEST_NAME}"
        PROPERTY EASYTEST_CATEGORY "${FN_CATEGORY}"
    )
endfunction()

include(scripts/test/gtest.cmake)
