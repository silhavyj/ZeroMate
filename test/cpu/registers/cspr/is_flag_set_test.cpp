#include <gtest/gtest.h>

#include "cpu/registers/cspr.hpp"

TEST(is_flag_set, test_01)
{
    using namespace zero_mate::cpu;
    const CCSPR cspr{ (0b1U << CCSPR::N_BIT_IDX) | (0b1U << CCSPR::Z_BIT_IDX) };

    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(is_flag_set, test_02)
{
    using namespace zero_mate::cpu;
    const CCSPR cspr{ 0 };

    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(is_flag_set, test_03)
{
    using namespace zero_mate::cpu;
    const CCSPR cspr{ 0b11110000'00000000'00000000'00000000U };

    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::V), true);
}

TEST(is_flag_set, test_04)
{
    using namespace zero_mate::cpu;
    const CCSPR cspr{ 0b10100000'00000000'00000000'00000000U };

    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}