/*
 * Copyright 2018 Google LLC.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

// Examples of StatusOr usage in C++ for CLIF bindings and tests.
#ifndef THIRD_PARTY_NUCLEUS_VENDOR_STATUSOR_EXAMPLES_H_
#define THIRD_PARTY_NUCLEUS_VENDOR_STATUSOR_EXAMPLES_H_

#include "third_party/nucleus/vendor/statusor.h"
#include "third_party/nucleus/platform/types.h"

namespace nucleus {

using tensorflow::Status;

static StatusOr<int> MakeIntOK() {
  return 42;
}

static StatusOr<int> MakeIntFail() {
  return Status(tensorflow::error::INVALID_ARGUMENT, "MakeIntFail");
}

static StatusOr<string> MakeStrOK() {
  return string("hello");
}

static StatusOr<string> MakeStrOKStrippedType() {
  return string("hello");
}

static StatusOr<string> MakeStrFail() {
  return Status(tensorflow::error::INVALID_ARGUMENT, "MakeStrFail");
}

static StatusOr<std::unique_ptr<int>> MakeIntUniquePtrOK() {
  return std::unique_ptr<int>(new int(421));
}

static StatusOr<std::unique_ptr<int>> MakeIntUniquePtrFail() {
  return Status(tensorflow::error::INVALID_ARGUMENT, "MakeIntUniquePtrFail");
}

static StatusOr<std::unique_ptr<std::vector<int>>> MakeIntVectorOK() {
  return std::unique_ptr<std::vector<int>>(new std::vector<int>({1, 2, 42}));
}

static StatusOr<std::unique_ptr<std::vector<int>>> MakeIntVectorFail() {
  return Status(tensorflow::error::INVALID_ARGUMENT, "MakeIntVectorFail");
}

static Status FuncReturningStatusOK() { return Status(); }

static Status FuncReturningStatusFail() {
  return Status(tensorflow::error::INVALID_ARGUMENT, "FuncReturningStatusFail");
}

}  // namespace nucleus

#endif  // THIRD_PARTY_NUCLEUS_VENDOR_STATUSOR_EXAMPLES_H_
