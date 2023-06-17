#include <gtest/gtest.h>
#include <fmt/core.h>

#include "core/bus.hpp"
#include "core/arm1176jzf_s/core.hpp"
#include "core/peripherals/ram.hpp"

TEST(add_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a000aa }, // mov r0, #170
    { 0xe3a01b02 }, // mov r1, #2048
    { 0xe0901001 }  // adds r1, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 2218);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(add_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00102 }, // mvn r0, #-2147483648
    { 0xe3a01001 }, // mov r1, #1
    { 0xe0901001 }  // adds r1, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0x80000000);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(add_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #-2147483648
    { 0xe3e01000 }, // mov r1, #-1
    { 0xe0900001 }  // adds r0, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0xFFFFFFFF);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(add_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3a01000 }, // mov r1, #0
    { 0xe0900001 }  // adds r0, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[1], 0);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(add_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a0300f }, // mov r3, #15
    { 0xe1a00283 }, // mov r0, r3, LSL #5
    { 0xe3a01000 }, // mov r1, #0
    { 0xe0900001 }  // adds r0, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 480);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(add_instruction, test_06)
{
    using namespace zero_mate::arm1176jzf_s;

    const std::vector<std::uint32_t> ram_content = {
        0xe3a03003, // mov r3, #3
        0x108ff103  // addne pc, pc, r3, lsl #2
    };

    auto ram = std::make_shared<zero_mate::peripheral::CRAM>(1024, 0, ram_content);
    auto bus = std::make_shared<zero_mate::CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), zero_mate::CBus::NStatus::OK);

    CCPU_Core cpu{ 0, bus };

    cpu.Steps(2);

    EXPECT_EQ(cpu.Get_CPU_Context()[CCPU_Context::PC_Reg_Idx], 0x18);
}

TEST(add_instruction, test_07)
{
    using namespace zero_mate::arm1176jzf_s;

    const std::vector<std::uint32_t> ram_content = {
        0xe3a03002, // mov r3, #2
        0xe08fff13  // add pc, pc, r3, lsl pc
    };

    auto ram = std::make_shared<zero_mate::peripheral::CRAM>(1024, 0, ram_content);
    auto bus = std::make_shared<zero_mate::CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), zero_mate::CBus::NStatus::OK);

    CCPU_Core cpu{ 0, bus };

    cpu.Steps(2);

    EXPECT_EQ(cpu.Get_CPU_Context()[CCPU_Context::PC_Reg_Idx], 0x200C);
}

TEST(add_instruction, test_08)
{
    using namespace zero_mate::arm1176jzf_s;

    const std::vector<std::uint32_t> ram_content = {
        0xe3a03002, // mov r3, #2
        0xe08f0f13  // add r0, pc, r3, lsl pc
    };

    auto ram = std::make_shared<zero_mate::peripheral::CRAM>(1024, 0, ram_content);
    auto bus = std::make_shared<zero_mate::CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), zero_mate::CBus::NStatus::OK);

    CCPU_Core cpu{ 0, bus };

    cpu.Steps(2);

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 0x200C);
}

TEST(add_instruction, test_09)
{
    using namespace zero_mate::arm1176jzf_s;

    const std::vector<std::uint32_t> ram_content = {
        0xe3a03002, // mov r3, #2
        0xe0830f13  // add r0, r3, r3, lsl pc
    };

    auto ram = std::make_shared<zero_mate::peripheral::CRAM>(1024, 0, ram_content);
    auto bus = std::make_shared<zero_mate::CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), zero_mate::CBus::NStatus::OK);

    CCPU_Core cpu{ 0, bus };

    cpu.Steps(2);

    EXPECT_EQ(cpu.Get_CPU_Context()[0], 0x2002);
}