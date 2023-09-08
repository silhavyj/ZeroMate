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
//    vcvt.u32.f32 s2, s0
//    vcvt.s32.f32 s3, s0
//
//    vmov.f32 r2, s2
//    vmov.f32 r3, s3
//
// val0:
//    .float 3.40282

namespace
{
    void Run_Test(float f1, std::uint32_t result_u32, std::uint32_t result_s32, bool float_to_int = true)
    {
        CCPU_Core cpu{};

        auto bus = std::make_shared<CBus>();
        auto cp15 = std::make_shared<CCP15>(cpu.Get_CPU_Context());
        auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

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
        });

        cpu.Execute({
        { float_to_int ? 0xeebc1ac0 : 0xeeb81a40 }, // vcvt.u32.f32 s2, s0 | vcvt.f32.u32 s2, s0
        { float_to_int ? 0xeefd1ac0 : 0xeef81ac0 }, // vcvt.s32.f32 s3, s0 | vcvt.f32.s32 s3, s0
        { 0xee112a10 }, // vmov.f32 r2, s2
        { 0xee113a90 }, // vmov.f32 r3, s3
        });

        EXPECT_EQ(cpu.Get_CPU_Context()[2], result_u32);
        EXPECT_EQ(cpu.Get_CPU_Context()[3], result_s32);
    }
}

TEST(vctc, test_01)
{
    const float f1{ 3.40282F };
    const std::uint32_t result_u32{ 3 };

    Run_Test(f1, result_u32, result_u32);
}

TEST(vctc_float_to_int, test_02)
{
    const float f1{ -3.40282e+38F };
    const std::uint32_t result_u32{ 0x0 };
    const std::uint32_t result_s32{ 0x80000000 };

    Run_Test(f1, result_u32, result_s32);
}

TEST(vctc_float_to_int, test_03)
{
    const float f1{ 1.17549e-38F };
    const std::uint32_t result_u32{ 0x0 };
    const std::uint32_t result_s32{ 0x0 };

    Run_Test(f1, result_u32, result_s32);
}

TEST(vctc_float_to_int, test_04)
{
    const float f1{ -1.17549e-38F };
    const std::uint32_t result_u32{ 0x0 };
    const std::uint32_t result_s32{ 0x0 };

    Run_Test(f1, result_u32, result_s32);
}

TEST(vctc_float_to_int, test_05)
{
    const float f1{ 1.17549F };
    const std::uint32_t result_u32{ 0x1 };
    const std::uint32_t result_s32{ 0x1 };

    Run_Test(f1, result_u32, result_s32);
}

TEST(vctc_int_to_float, test_01)
{
    const float f1{ 1024.0F };
    const std::uint32_t result_u32{ 0x4e890000 };
    const std::uint32_t result_s32{ 0x4e890000 };

    Run_Test(f1, result_u32, result_s32, false);
}

TEST(vctc_int_to_float, test_02)
{
    const float f1{ -1333.333F };
    const std::uint32_t result_u32{ 0x4f44a6ab };
    const std::uint32_t result_s32{ 0xce6d6555 };

    Run_Test(f1, result_u32, result_s32, false);
}

TEST(vctc_int_to_float, test_03)
{
    const float f1{ -0.0F };
    const std::uint32_t result_u32{ 0x4f000000 };
    const std::uint32_t result_s32{ 0xcf000000 };

    Run_Test(f1, result_u32, result_s32, false);
}

TEST(vctc_int_to_float, test_04)
{
    const float f1{ 0.0F };
    const std::uint32_t result_u32{ 0x0 };
    const std::uint32_t result_s32{ 0x0 };

    Run_Test(f1, result_u32, result_s32, false);
}

TEST(vctc_int_to_float, test_05)
{
    const float f1{ 2147483647.0F };
    const std::uint32_t result_u32{ 0x4e9e0000 };
    const std::uint32_t result_s32{ 0x4e9e0000 };

    Run_Test(f1, result_u32, result_s32, false);
}

TEST(vctc_int_to_float, test_06)
{
    const float f1{ 4294967295.0F };
    const std::uint32_t result_u32{ 0x4e9f0000 };
    const std::uint32_t result_s32{ 0x4e9f0000 };

    Run_Test(f1, result_u32, result_s32, false);
}