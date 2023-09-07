#include <bit>
#include <limits>
#include <memory>

#include "gtest/gtest.h"

#include "core/arm1176jzf_s/core.hpp"
#include "core/coprocessors/cp10/cp10.hpp"

using namespace zero_mate;
using namespace arm1176jzf_s;
using namespace coprocessor::cp10;
using namespace coprocessor::cp15;

// .global _start
//_start:
//
//    mov sp, #1024
//    mrc p15, 0, r6, c1, c0, 2
//    orr r6, r6, #0x300000
//    mcr p15, 0, r6, c1, c0, 2
//    mov r6, #0x40000000
//    fmxr fpexc, r6
//
//    ldr r0, =val0
//    ldr r0, [r0]
//
//    ldr r1, =val1
//    ldr r1, [r1]
//
//    vmov.f32 s0, r0
//    vmov.f32 s1, r1
//
//    vnmul.f32 s2, s0, s1
//    vmov.f32 r2, s2
//
// val0:
//     .float 3.40282e+38
//
// val1:
//     .float 1.17549e-38

namespace
{
    [[maybe_unused]] void Run_Test_Common(CCPU_Core& cpu, std::shared_ptr<CCP10> cp10, float f1, float f2)
    {
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

        cpu.Get_CPU_Context()[0] = std::bit_cast<std::uint32_t>(f1);
        cpu.Get_CPU_Context()[1] = std::bit_cast<std::uint32_t>(f2);

        cpu.Execute({
        { 0xee000a10 }, // vmov.f32 s0, r0
        { 0xee001a90 }, // vmov.f32 s1, r1
        });

        cpu.Execute({
        { 0xee201a60 }, // vnmul.f32 s2, s0, s1
        { 0xee112a10 }, // vmov.f32 r2, s2
        });
    }

    [[maybe_unused]] void Run_Test(float f1, float f2, float result)
    {
        CCPU_Core cpu{};
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context());

        Run_Test_Common(cpu, cp10, f1, f2);

        EXPECT_TRUE(cp10->Get_Registers()[2] == result);
    }

    [[maybe_unused]] void Run_Test(float f1, float f2, std::uint32_t result)
    {
        CCPU_Core cpu{};
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context());

        Run_Test_Common(cpu, cp10, f1, f2);

        EXPECT_EQ(cpu.Get_CPU_Context()[2], result);
    }

    [[maybe_unused]] void Run_Test(float f1, float f2, float result_float, std::uint32_t result_uint32)
    {
        CCPU_Core cpu{};
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context());

        Run_Test_Common(cpu, cp10, f1, f2);

        EXPECT_TRUE(cp10->Get_Registers()[2] == result_float);
        EXPECT_EQ(cpu.Get_CPU_Context()[2], result_uint32);
    }
}

TEST(vnmul, test_01)
{
    const float f1{ 0.65F };
    const float f2{ -0.169F };

    const float result_float{ 0.10985F };
    const std::uint32_t result_uint32{ 0x3de0f909 };

    Run_Test(f1, f2, result_float, result_uint32);
}

TEST(vnmul, test_02)
{
    const float f1{ 3.40282e+38F };
    const float f2{ 3.40282e+38F };

    const std::uint32_t result_uint32{ 0xff800000 };

    Run_Test(f1, f2, result_uint32);
}

TEST(vnmul, test_03)
{
    const float f1{ 1.17549e-38F };
    const float f2{ 3.40282e+38F };

    const float result_float{ -3.99998F };
    const std::uint32_t result_uint32{ 0xc07fffb0 };

    Run_Test(f1, f2, result_float, result_uint32);
}

TEST(vnmul, test_04)
{
    const float f1{ 1.17549e-38F };
    const float f2{ 0.000001F };

    const float result_float{ 0.0F };
    const std::uint32_t result_uint32{ 0x80000008 };

    Run_Test(f1, f2, result_float, result_uint32);
}