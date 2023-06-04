#include <memory>

#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

TEST(enable_unaligned_access, test_01)
{
    arm1176jzf_s::CCPU_Core cpu{};
    const auto cp15 = std::make_shared<coprocessor::CCP15>(cpu.Get_CPU_Context());

    cpu.Add_Coprocessor(coprocessor::CCP15::ID, cp15);

    EXPECT_EQ(cp15->Is_Unaligned_Access_Permitted(), true);

    cpu.Execute({
    { 0xee114f10 }, // mrc p15, #0, r4, c1, c0, #0
    { 0xe3844501 }, // orr r4, #0x400000
    { 0xee014f10 }  // mcr p15, #0, r4, c1, c0, #0
    });

    EXPECT_EQ(cp15->Is_Unaligned_Access_Permitted(), true);
}

TEST(disable_unaligned_access, test_02)
{
    arm1176jzf_s::CCPU_Core cpu{};
    const auto cp15 = std::make_shared<coprocessor::CCP15>(cpu.Get_CPU_Context());

    cpu.Add_Coprocessor(coprocessor::CCP15::ID, cp15);

    EXPECT_EQ(cp15->Is_Unaligned_Access_Permitted(), true);

    cpu.Execute({
    { 0xee114f10 }, // mrc p15, #0, r4, c1, c0, #0
    { 0xe3e03501 }, // mvn r3, #0x400000
    { 0xe0044003 }, // and r4, r4, r3
    { 0xee014f10 }  // mcr p15, #0, r4, c1, c0, #0
    });

    EXPECT_EQ(cp15->Is_Unaligned_Access_Permitted(), false);
}