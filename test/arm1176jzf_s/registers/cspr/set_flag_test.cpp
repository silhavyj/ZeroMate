#include <gtest/gtest.h>

#include "core/arm1176jzf_s/registers/cspr.hpp"

TEST(set_flag_set, test_01)
{
    using namespace zero_mate::arm1176jzf_s;
    CCSPR cspr{ 0 };

    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::V), false);

    cspr.Set_Flag(CCSPR::NFlag::N, true);

    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(set_flag_set, test_02)
{
    using namespace zero_mate::arm1176jzf_s;
    CCSPR cspr{ 0b11110000'00000000'00000000'00000000U };

    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::V), true);

    cspr.Set_Flag(CCSPR::NFlag::N, false);

    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::V), true);
}

TEST(set_flag_set, test_03)
{
    using namespace zero_mate::arm1176jzf_s;
    CCSPR cspr{ 0b00000000'00000000'00000000'00000000U };

    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::V), false);

    cspr.Set_Flag(CCSPR::NFlag::N, false);
    cspr.Set_Flag(CCSPR::NFlag::Z, false);
    cspr.Set_Flag(CCSPR::NFlag::C, false);
    cspr.Set_Flag(CCSPR::NFlag::V, false);

    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}