#include <memory>

#include "gtest/gtest.h"

#include "core/arm1176jzf_s/core.hpp"
#include "core/coprocessors/cp10/cp10.hpp"

using namespace zero_mate;
using namespace arm1176jzf_s;
using namespace coprocessor::cp10;
using namespace coprocessor::cp15;

TEST(vmul, test_01)
{
    CCPU_Core cpu{};

    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context());
    auto cp15 = std::make_shared<CCP15>(cpu.Get_CPU_Context());

    cpu.Add_Coprocessor(CCP10::ID, cp10);
    cpu.Add_Coprocessor(CCP15::ID, cp15);

    cpu.Set_Coprocessor_15(cp15);

    cpu.Execute({
    { 0xe3a0db01 }, // mov sp, #1024
    { 0xee116f50 }, // mrc p15, 0, r6, c1, c0, 2
    { 0xe3866603 }, // orr r6, r6, #0x300000
    { 0xee016f50 }, // mcr p15, 0, r6, c1, c0, 2
    { 0xe3a06101 }, // mov r6, #0x40000000
    { 0xeee86a10 }, // fmxr fpexc, r6
    });

    cpu.Get_CPU_Context()[0] = 0x3f266666; // r0 = 0.65
    cpu.Get_CPU_Context()[1] = 0xbe2d0e56; // r1 = -0.169

    cpu.Execute({
    { 0xee000a10 }, // vmov.f32 s0, r0
    { 0xee001a90 }, // vmov.f32 s1, r1
    });

    cpu.Execute({
    { 0xee201a20 }, // vmul.f32 s2, s0, s1
    { 0xee112a10 }, // vmov.f32 r2, s2
    });

    EXPECT_TRUE(cp10->Get_Registers()[2] == -0.10985F);
    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0xbde0f909);
}
