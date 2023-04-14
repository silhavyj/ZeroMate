#include <gtest/gtest.h>

#include "core/arm1176jzf_s/registers/cpsr.hpp"

TEST(set_flag_set, test_01)
{
    using namespace zero_mate::arm1176jzf_s;
    CCPSR cpsr{ 0 };

    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::N), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::Z), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::C), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);

    cpsr.Set_Flag(CCPSR::NFlag::N, true);

    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::N), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::Z), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::C), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);
}

TEST(set_flag_set, test_02)
{
    using namespace zero_mate::arm1176jzf_s;
    CCPSR cpsr{ 0b11110000'00000000'00000000'00000000U };

    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::N), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::Z), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::C), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::V), true);

    cpsr.Set_Flag(CCPSR::NFlag::N, false);

    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::N), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::Z), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::C), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::V), true);
}

TEST(set_flag_set, test_03)
{
    using namespace zero_mate::arm1176jzf_s;
    CCPSR cpsr{ 0b00000000'00000000'00000000'00000000U };

    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::N), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::Z), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::C), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);

    cpsr.Set_Flag(CCPSR::NFlag::N, false);
    cpsr.Set_Flag(CCPSR::NFlag::Z, false);
    cpsr.Set_Flag(CCPSR::NFlag::C, false);
    cpsr.Set_Flag(CCPSR::NFlag::V, false);

    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::N), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::Z), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::C), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);
}