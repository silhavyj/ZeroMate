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

TEST(vstm, test_01)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3a000c8 }, // mov r0, #200
    { 0xeca01a02 }, // vstmia r0!, {s2, s3}
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 0xD0);

    cpu.Execute({
    { 0xe3a000c8 }, // mov r0, #200
    { 0xe8900030 }, // ldm r0, {r4-r5}
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[4], 2);
    EXPECT_EQ(cpu.Get_CPU_Context()[5], 3);
}

TEST(vstm, test_02)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3a000c8 }, // mov r0, #200
    { 0xec801a02 }, // vstmia r0, {s2, s3}
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 200);

    cpu.Execute({
    { 0xe8900030 }, // ldm r0, {r4-r5}
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[4], 2);
    EXPECT_EQ(cpu.Get_CPU_Context()[5], 3);
}

TEST(vstm, test_03)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3a000c8 }, // mov r0, #200
    { 0xed201a02 }, // vstmdb r0!, {s2, s3}
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 0xC0);

    cpu.Execute({
    { 0xe3a000c0 }, // mov r0, #192
    { 0xe8900030 }, // ldm r0, {r4-r5}
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[4], 2);
    EXPECT_EQ(cpu.Get_CPU_Context()[5], 3);
}