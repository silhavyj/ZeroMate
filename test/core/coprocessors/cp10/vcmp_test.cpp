#include <bit>
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
//    vcmp.f32 s0, #0
//    vmrs apsr_nzcv, fpscr
//
// val0:
//     .float 1.0

// .global _start
//_start:
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
//    vcmp.f32 s0, s1
//    vmrs apsr_nzcv, fpscr
//
// val0:
//     .float -0.00001
//
// val1:
//     .float -0.00001

namespace
{
    void Run_CMP_Zero_Test(CCPU_Core& cpu, float f1)
    {
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context());
        auto cp15 = std::make_shared<CCP15>(cpu.Get_CPU_Context());

        cpu.Add_Coprocessor(CCP10::ID, cp10);
        cpu.Add_Coprocessor(CCP15::ID, cp15);

        cpu.Set_Coprocessor_15(cp15);

        cpu.Execute({
        { 0xee116f50 }, // mrc p15, 0, r6, c1, c0, 2
        { 0xe3866603 }, // orr r6, r6, #0x300000
        { 0xee016f50 }, // mcr p15, 0, r6, c1, c0, 2
        { 0xe3a06101 }, // mov r6, #0x40000000
        { 0xeee86a10 }  // fmxr fpexc, r6
        });

        cpu.Get_CPU_Context()[0] = std::bit_cast<std::uint32_t>(f1);

        cpu.Execute({
        { 0xee000a10 }, // vmov.f32 s0, r0
        { 0xeeb50a40 }, // vcmp.f32 s0, #0
        { 0xeef1fa10 }  // vmrs apsr_nzcv, fpscr
        });
    }

    void Run_CMP_Test(CCPU_Core& cpu, float f1, float f2)
    {
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context());
        auto cp15 = std::make_shared<CCP15>(cpu.Get_CPU_Context());

        cpu.Add_Coprocessor(CCP10::ID, cp10);
        cpu.Add_Coprocessor(CCP15::ID, cp15);

        cpu.Set_Coprocessor_15(cp15);

        cpu.Execute({
        { 0xee116f50 }, // mrc p15, 0, r6, c1, c0, 2
        { 0xe3866603 }, // orr r6, r6, #0x300000
        { 0xee016f50 }, // mcr p15, 0, r6, c1, c0, 2
        { 0xe3a06101 }, // mov r6, #0x40000000
        { 0xeee86a10 }  // fmxr fpexc, r6
        });

        cpu.Get_CPU_Context()[0] = std::bit_cast<std::uint32_t>(f1);
        cpu.Get_CPU_Context()[1] = std::bit_cast<std::uint32_t>(f2);

        cpu.Execute({
        { 0xee000a10 }, // vmov.f32 s0, r0
        { 0xee001a90 }, // vmov.f32 s1, r1
        { 0xeeb40a60 }, // vcmp.f32 s0, s1
        { 0xeef1fa10 }  // vmrs apsr_nzcv, fpscr
        });
    }
}

TEST(vcmp_zero, test_01)
{
    CCPU_Core cpu{};

    Run_CMP_Zero_Test(cpu, 0.0F);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(vcmp_zero, test_02)
{
    CCPU_Core cpu{};

    Run_CMP_Zero_Test(cpu, 0.00001F);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(vcmp_zero, test_03)
{
    CCPU_Core cpu{};

    Run_CMP_Zero_Test(cpu, -0.00001F);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(vcmp, test_01)
{
    CCPU_Core cpu{};

    Run_CMP_Test(cpu, -0.00001F, -0.00001F);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(vcmp, test_02)
{
    CCPU_Core cpu{};

    Run_CMP_Test(cpu, 3.40282e+38F, -3.40282e+38F);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(vcmp, test_03)
{
    CCPU_Core cpu{};

    Run_CMP_Test(cpu, -1.17549e-38F, 2.0F);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}