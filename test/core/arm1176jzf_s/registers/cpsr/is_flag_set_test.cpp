#include <gtest/gtest.h>

#include "core/arm1176jzf_s/registers/cpsr.hpp"

TEST(is_flag_set, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    const CCPSR cpsr{ (0b1U << CCPSR::N_BIT_IDX) | (0b1U << CCPSR::Z_BIT_IDX) };

    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::N), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::Z), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::C), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);
}

TEST(is_flag_set, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    const CCPSR cpsr{ 0 };

    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::N), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::Z), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::C), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);
}

TEST(is_flag_set, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    const CCPSR cpsr{ 0b11110000'00000000'00000000'00000000U };

    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::N), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::Z), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::C), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::V), true);
}

TEST(is_flag_set, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    const CCPSR cpsr{ 0b10100000'00000000'00000000'00000000U };

    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::N), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::Z), false);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::C), true);
    EXPECT_EQ(cpsr.Is_Flag_Set(CCPSR::NFlag::V), false);
}