#!/bin/bash

# Copyright 2019 Tetrate
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

set -e

curl -sSL https://raw.githubusercontent.com/llvm/llvm-project/llvmorg-8.0.1/llvm/utils/release/test-release.sh | sed 's,http://llvm.org,https://llvm.org,' > /home/build/test-release.sh
chmod +x /home/build/test-release.sh

mkdir -p ${BUILD_DIR}
chown build:build ${BUILD_DIR}

CLANG_CONFIGURE_FLAGS="
-DCOMPILER_RT_BUILD_LIBFUZZER=off
-DCLANG_DEFAULT_CXX_STDLIB=libc++
-DCLANG_DEFAULT_RTLIB=compiler-rt
-DCLANG_DEFAULT_LINKER=lld
"


sudo -u build scl enable devtoolset-7 llvm-toolset-7 \
  "env CC=clang CXX=clang++ LDFLAGS=-lm \
    /home/build/test-release.sh -release 8.0.1 -final -triple x86_64-linux-centos7_libcxx \
    -configure-flags '${CLANG_CONFIGURE_FLAGS}' -build-dir ${BUILD_DIR}"
