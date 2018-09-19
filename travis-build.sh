#!/usr/bin/env bash
# ----------------------------------------------------------------------------------------------------------------------
# The MIT License (MIT)
#
# Copyright (c) 2018 Ralph-Gordon Paul. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the 
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ----------------------------------------------------------------------------------------------------------------------

set -e

#=======================================================================================================================
# globals

declare ABSOLUTE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare TRAVIS_BOOST_VERSION2=${TRAVIS_BOOST_VERSION//./_}

#=======================================================================================================================

function build()
{
    cd "${ABSOLUTE_DIR}"

    ./build-android.sh --boost=${TRAVIS_BOOST_VERSION} ${TRAVIS_BUILD_DIR}/android-ndk-${TRAVIS_ANDROID_NDK_VERSION}
}

#=======================================================================================================================

function restructureOutput()
{
    cd "${ABSOLUTE_DIR}/build"

    # copy header files
    mkdir -p "${ABSOLUTE_DIR}/build/include"
    mkdir "${ABSOLUTE_DIR}/build/lib"
    cp -r "${ABSOLUTE_DIR}/boost_${TRAVIS_BOOST_VERSION2}/boost" "${ABSOLUTE_DIR}/build/include/"

    # goto created library files and iterate over all architectures
    cd "${ABSOLUTE_DIR}/build/out"

    for folder in *; do
        echo "folder: $folder"

        rm -r "${ABSOLUTE_DIR}/build/out/${folder}/include"
        
        cd "${ABSOLUTE_DIR}/build/out/${folder}/lib"

        for file in *.a; do
            mv $file "../${file%%-*}.a"
        done

        rm -r "${ABSOLUTE_DIR}/build/out/${folder}/lib"
        mv "${ABSOLUTE_DIR}/build/out/${folder}" "${ABSOLUTE_DIR}/build/lib/"
    done

    cd "${ABSOLUTE_DIR}"
}

#=======================================================================================================================

build
restructureOutput
