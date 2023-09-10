#include <bit>
#include <memory>

#include "gtest/gtest.h"

#include "core/bus.hpp"
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
//    ldr r2, =val2
//    ldr r2, [r2]
//
//    vmov.f32 s0, r0
//    vmov.f32 s1, r1
//    vmov.f32 s2, r2
//
//    vmla.f32 s2, s0, s1
//    vmov.f32 r2, s2
//
// val0:
//     .float 3.40282e+38
//
// val1:
//     .float 1.17549e-38
//
// val2:
//     .float 1.17549e-38

namespace
{
    [[maybe_unused]] void Run_Test_Common(CCPU_Core& cpu, std::shared_ptr<CCP10> cp10, float f1, float f2, float vd)
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
        cpu.Get_CPU_Context()[2] = std::bit_cast<std::uint32_t>(vd);

        cpu.Execute({
        { 0xee000a10 }, // vmov.f32 s0, r0
        { 0xee001a90 }, // vmov.f32 s1, r1
        { 0xee012a10 }, // vmov.f32 s2, r2
        });

        cpu.Execute({
        { 0xee001a20 }, // vmla.f32 s2, s0, s1
        { 0xee112a10 }, // vmov.f32 r2, s2
        });
    }

    [[maybe_unused]] void Run_Test(float f1, float f2, float vd, float result)
    {
        CCPU_Core cpu{};

        auto bus = std::make_shared<CBus>();
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

        Run_Test_Common(cpu, cp10, f1, f2, vd);

        EXPECT_TRUE(cp10->Get_Registers()[2] == result);
    }

    [[maybe_unused]] void Run_Test(float f1, float f2, float vd, std::uint32_t result)
    {
        CCPU_Core cpu{};

        auto bus = std::make_shared<CBus>();
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

        Run_Test_Common(cpu, cp10, f1, f2 ,vd);

        EXPECT_EQ(cpu.Get_CPU_Context()[2], result);
    }

    [[maybe_unused]] void Run_Test(float f1, float f2, float vd, float result_float, std::uint32_t result_uint32)
    {
        CCPU_Core cpu{};

        auto bus = std::make_shared<CBus>();
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

        Run_Test_Common(cpu, cp10, f1, f2, vd);

        EXPECT_TRUE(cp10->Get_Registers()[2] == result_float);
        EXPECT_EQ(cpu.Get_CPU_Context()[2], result_uint32);
    }
}

TEST(vmla, test_01)
{
    const float f1{ 0.65F };
    const float f2{ -0.169F };
    const float vd{ -123456.9998F };

    const float result_float{ -123457.1094F };
    const std::uint32_t result_uint32{ 0xc7f1208e };

    Run_Test(f1, f2, vd, result_float, result_uint32);
}

TEST(vmla, test_02)
{
    const float f1{ 71.59858F };
    const float f2{ 11.1118F };
    const float vd{ 0.25698F };

    const float result_float{ 795.8460693F };
    const std::uint32_t result_uint32{ 0x4446f626 };

    Run_Test(f1, f2, vd, result_float, result_uint32);
}

TEST(vmla, test_03)
{
    const float f1{ 3.40282e+38F };
    const float f2{ 3.40282e+38F };
    const float vd{ 3.40282e+38F };

    const std::uint32_t result_uint32{ 0x7f800000 };

    Run_Test(f1, f2, vd, result_uint32);
}

TEST(vmla, test_04)
{
    const float f1{ -1.17549e-38F };
    const float f2{ -1.17549e-38F };
    const float vd{ 1.17549e-38F };

    const float result_float{ 1.175490007e-38F };
    const std::uint32_t result_uint32{ 0x007fffe1 };

    Run_Test(f1, f2, vd, result_float, result_uint32);
}