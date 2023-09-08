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
//    vmov.f32 s0, r0
//
//    vabs.f32 s2, s0
//    vmov.f32 r2, s2
//
// val0:
//     .float 3.40282e+38

namespace
{
    [[maybe_unused]] void Run_Test_Common(CCPU_Core& cpu, std::shared_ptr<CCP10> cp10, float f1)
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

        cpu.Execute({
        { 0xee000a10 }, // vmov.f32 s0, r0
        { 0xee001a90 }, // vmov.f32 s1, r1
        });

        cpu.Execute({
        { 0xeeb01ac0 }, // vabs.f32 s2, s0
        { 0xee112a10 }, // vmov.f32 r2, s2
        });
    }

    [[maybe_unused]] void Run_Test(float f1, float result)
    {
        CCPU_Core cpu{};

        auto bus = std::make_shared<CBus>();
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

        Run_Test_Common(cpu, cp10, f1);

        EXPECT_TRUE(cp10->Get_Registers()[2] == result);
    }

    [[maybe_unused]] void Run_Test(float f1, std::uint32_t result)
    {
        CCPU_Core cpu{};

        auto bus = std::make_shared<CBus>();
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

        Run_Test_Common(cpu, cp10, f1);

        EXPECT_EQ(cpu.Get_CPU_Context()[2], result);
    }

    [[maybe_unused]] void Run_Test(float f1, float result_float, std::uint32_t result_uint32)
    {
        CCPU_Core cpu{};

        auto bus = std::make_shared<CBus>();
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

        Run_Test_Common(cpu, cp10, f1);

        EXPECT_TRUE(cp10->Get_Registers()[2] == result_float);
        EXPECT_EQ(cpu.Get_CPU_Context()[2], result_uint32);
    }
}

TEST(vabs, test_01)
{
    const float f1{ -3.40282e+38F };

    const float result_float{ 3.40282e+38F };
    const std::uint32_t result_uint32{ 0x7f7fffee };

    Run_Test(f1, result_float, result_uint32);
}

TEST(vabs, test_02)
{
    const float f1{ -123.56985F };

    const float result_float{ 123.56985F };
    const std::uint32_t result_uint32{ 0x42f723c3 };

    Run_Test(f1, result_float, result_uint32);
}

TEST(vabs, test_03)
{
    const float f1{ -1.17549e-38F };

    const float result_float{ 1.17549e-38F };
    const std::uint32_t result_uint32{ 0x007fffe1 };

    Run_Test(f1, result_float, result_uint32);
}


