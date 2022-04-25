# Copyright (c) 2022: Miles Lubin and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using JuMP, HiGHS
model = direct_model(HiGHS.Optimizer())
@variable(model, x)
highs = backend(model) # A pointer to the highs problem
Highs_scaleCol(highs, HiGHS.column(model, x), 0.1)
