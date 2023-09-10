#include <memory>

#include "gtest/gtest.h"

#include "core/bus.hpp"
#include "core/arm1176jzf_s/core.hpp"
#include "core/coprocessors/cp10/cp10.hpp"
#include "core/peripherals/ram.hpp"

using namespace zero_mate;
using namespace arm1176jzf_s;
using namespace coprocessor::cp10;
using namespace coprocessor::cp15;

namespace
{
    void Init_Test(CCPU_Core& cpu, std::shared_ptr<CBus>& bus, std::shared_ptr<CCP10>& cp10)
    {
        auto ram = std::make_shared<peripheral::CRAM>(1024);
        auto cp15 = std::make_shared<CCP15>(cpu.Get_CPU_Context());

        cpu.Add_Coprocessor(CCP10::ID, cp10);
        cpu.Add_Coprocessor(CCP15::ID, cp15);

        cpu.Set_Coprocessor_15(cp15);

        EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

        cpu.Execute({
        { 0xe3a0db01 }, // mov sp, #1024
        { 0xee116f50 }, // mrc p15, 0, r6, c1, c0, 2
        { 0xe3866603 }, // orr r6, r6, #0x300000
        { 0xee016f50 }, // mcr p15, 0, r6, c1, c0, 2
        { 0xe3a06101 }, // mov r6, #0x40000000
        { 0xeee86a10 }, // fmxr fpexc, r6
        });

        cpu.Execute({
        { 0xe3a00000 }, // mov r0, #0
        { 0xe3a01001 }, // mov r1, #1
        { 0xe3a02002 }, // mov r2, #2
        { 0xe3a03003 }, // mov r3, #3
        });

        cpu.Execute({
        { 0xee000a10 }, // vmov.f32 s0, r0
        { 0xee001a90 }, // vmov.f32 s1, r1
        { 0xee012a10 }, // vmov.f32 s2, r2
        { 0xee013a90 }, // vmov.f32 s3, r3
        });
    }
}

TEST(vpush, test_01)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xed2d0a04 }, // vpush.f32 { s0, s1, s2, s3 }
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[CCPU_Context::SP_Reg_Idx], 0x3F0);

    cpu.Execute({
    { 0xe3a00ffd }, // mov r0, #1012
    { 0xe8900030 }, // ldm r0, {r4-r5}
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[4], 1);
    EXPECT_EQ(cpu.Get_CPU_Context()[5], 2);
}

TEST(vpop, test_01)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xed2d1a02 }, // vpush.f32 { s2, s3 }
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[CCPU_Context::SP_Reg_Idx], 0x3f8);

    cpu.Execute({
    { 0xecbd0a02 }, // vpop.f32 { s1, s0 }
    });

    EXPECT_EQ(cp10->Get_Registers()[0].Get_Value_As<std::uint32_t>(), 2);
    EXPECT_EQ(cp10->Get_Registers()[1].Get_Value_As<std::uint32_t>(), 3);
}