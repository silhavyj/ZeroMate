// ---------------------------------------------------------------------------------------------------------------------
/// \file isa.hpp
/// \date 25. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file is just a helper file for including all ARM instructions supported by the emulator.
// ---------------------------------------------------------------------------------------------------------------------

#pragma once

#include "instruction.hpp"
#include "branch_and_exchange.hpp"
#include "branch.hpp"
#include "data_processing.hpp"
#include "multiply.hpp"
#include "multiply_long.hpp"
#include "single_data_transfer.hpp"
#include "block_data_transfer.hpp"
#include "halfword_data_transfer.hpp"
#include "extend.hpp"
#include "psr_transfer.hpp"
#include "cps.hpp"
#include "coprocessor_register_transfer.hpp"
#include "coprocessor_data_transfer.hpp"
#include "coprocessor_data_operation.hpp"
#include "srs.hpp"
#include "rfe.hpp"
#include "clz.hpp"