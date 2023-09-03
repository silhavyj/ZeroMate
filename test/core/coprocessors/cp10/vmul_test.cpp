#include <memory>

#include "gtest/gtest.h"

#include "core/coprocessors/cp10/cp10.hpp"
#include "core/arm1176jzf_s/isa/instruction.hpp"
#include "core/arm1176jzf_s/isa/coprocessor_data_operation.hpp"

using namespace zero_mate;

TEST(vmul, test_01)
{
    using namespace coprocessor::cp10;

    arm1176jzf_s::CCPU_Context cpu_context{};

    CCP10 cp10{ cpu_context };

    cp10.Get_Registers()[0] = 0.65F;
    cp10.Get_Registers()[1] = 0.15F;

    const arm1176jzf_s::isa::CCoprocessor_Data_Operation cp_inst{ arm1176jzf_s::isa::CInstruction{ 0xee201a20 } };

    cp10.Perform_Data_Operation(cp_inst);

    EXPECT_TRUE(cp10.Get_Registers()[2] == 0.0975F);
}