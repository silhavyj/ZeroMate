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
    }
}

TEST(vldr, test_01)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3a000c8 }, // mov r0, #200
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe5801000 }, // str r1, [r0]
    { 0xed900a00 }, // vldr s0, [r0]
    });

    EXPECT_EQ(cp10->Get_Registers()[0].Get_Value_As<std::uint32_t>(), 0xFF);
}

TEST(vldr, test_02)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3a000c8 }, // mov r0, #200
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe5801000 }, // str r1, [r0]
    { 0xed100a01 }, // vldr s0, [r0, #-4]
    });

    EXPECT_EQ(cp10->Get_Registers()[0].Get_Value_As<std::uint32_t>(), 0x0);
}

TEST(vldr, test_03)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3a000c8 }, // mov r0, #200
    { 0xe3a010ff }, // mov r1, #0xFF
    { 0xe5801000 }, // str r1, [r0]
    { 0xed900a01 }, // vldr s0, [r0, #4]
    });

    EXPECT_EQ(cp10->Get_Registers()[0].Get_Value_As<std::uint32_t>(), 0x0);
}

TEST(vldr, test_04)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3a0008c }, // mov r0, #140
    { 0xe3e010a1 }, // mvn r1, #0xA1
    { 0xe5801000 }, // str r1, [r0] mov r0, #200
    { 0xe3a000c8 }, // mov r0, #200
    { 0xed100a0f }, // vldr s0, [r0, #-60]
    });

    EXPECT_EQ(cp10->Get_Registers()[0].Get_Value_As<std::uint32_t>(), 0xffffff5e);
}

TEST(vstr, test_01)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xee000a10 }, // vmov.f32 s0, r0
    { 0xe3a000c8 }, // mov r0, #200
    { 0xed800a00 }, // vstr s0, [r0]
    { 0xe5901000 }, // ldr r1, [r0]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0xFF);
}

TEST(vstr, test_02)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xee000a10 }, // vmov.f32 s0, r0
    { 0xe3a000c8 }, // mov r0, #200
    { 0xed800a01 }, // vstr s0, [r0, #4]
    { 0xe5901000 }, // ldr r1, [r0]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x0);
}

TEST(vstr, test_03)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3a000ff }, // mov r0, #0xFF
    { 0xee000a10 }, // vmov.f32 s0, r0
    { 0xe3a000c8 }, // mov r0, #200
    { 0xed000a01 }, // vstr s0, [r0, #-4]
    { 0xe5901000 }, // ldr r1, [r0]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x0);
}

TEST(vstr, test_04)
{
    auto bus = std::make_shared<CBus>();
    CCPU_Core cpu{ 0, bus };
    auto cp10 = std::make_shared<CCP10>(cpu.Get_CPU_Context(), bus);

    Init_Test(cpu, bus, cp10);

    cpu.Execute({
    { 0xe3e000c9 }, // mvn r0, #0xC9
    { 0xee000a10 }, // vmov.f32 s0, r0
    { 0xe3a000c8 }, // mov r0, #200
    { 0xed800a10 }, // vstr s0, [r0, #64]
    { 0xe3a00f42 }, // mov r0, #264
    { 0xe5901000 }, // ldr r1, [r0]
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0xffffff36);
}