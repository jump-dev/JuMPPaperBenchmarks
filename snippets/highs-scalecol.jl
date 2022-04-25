# Copyright (c) 2022: Miles Lubin and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using JuMP, HiGHS
model = direct_model(HiGHS.Optimizer())
@variable(model, x)
#  A pointer to the highs problem
highs = backend(model)
#  0-indexed column of x in highs
col = HiGHS.column(highs, optimizer_index(x))
#  Call the C API
Highs_scaleCol(highs, col, 0.1)
