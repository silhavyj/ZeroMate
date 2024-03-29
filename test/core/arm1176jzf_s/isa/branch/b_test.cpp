#include "gtest/gtest.h"

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_Size = 1024;

TEST(b_instruction, test_01)
{
    const std::vector<std::uint32_t> ram_content = {
        0xe320f000, // 00000000     nop
        0xea000000, // 00000004     b label1
        0xe320f000, // 00000008     nop
                    //          label1:
        0xe320f000, // 0000000C     nop
        0xe320f000  // 00000010     nop
    };

    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size, 0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Steps(2);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 12);
}

TEST(b_instruction, test_02)
{
    const std::vector<std::uint32_t> ram_content = {
        0xe320f000, // 00000000     nop
        0xe320f000, // 00000004     nop
                    //          label1:
        0xe320f000, // 00000008     nop
        0xe320f000, // 0000000C     nop
        0xeafffffc, // 00000010     b label1
    };

    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size, 0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Steps(5);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 0x8);
}

TEST(b_instruction, test_03)
{
    const std::vector<std::uint32_t> ram_content = {
        //          label1:
        0xeafffffe, // 00000000     b label1
    };

    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size, 0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Steps(10);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 0x0);
}

TEST(b_instruction, test_04)
{
    const std::vector<std::uint32_t> ram_content = {
        0xea000004, // 00000000     b label4
        0xe320f000, // 00000004     nop
        0xe320f000, // 00000008     bop
                    //          label2:
        0xe320f000, // 0000000C     nop
        0xe320f000, // 00000010     nop
                    //          label3:
        0xeafffffe, // 00000014     b label3
                    //          label4:
        0xe320f000, // 00000018     nop
        0xeafffffa, // 0000001C     b label2
    };

    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size, 0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    // Jump immediately to label4
    cpu.Steps(1);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 0x18);

    // After a nop instruction, we should jump to label2
    cpu.Steps(2);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 0x0C);

    // After two nop instructions, we should be at label3
    cpu.Steps(2);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 0x14);

    // Infinite loop (stuck at label3)
    cpu.Steps(2);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 0x14);
}

TEST(b_instruction, test_05)
{
    const std::vector<std::uint32_t> ram_content = {
        0xe3a02000, // mov r2, #0
        0xe3a03001, // mov r3, #1
        0xe1520003, // cmp r2, r3
        0x3afffffb  // bcc 0x0
    };

    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size, 0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Steps(4);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 0x0);
}

TEST(b_instruction, test_06)
{
    const std::vector<std::uint32_t> ram_content = {
        0xe3a02000, // mov r2, #0
        0xe3a03000, // mov r3, #0
        0xe1520003, // cmp r2, r3
        0x3afffffb  // bcc 0x0
    };

    auto ram = std::make_shared<peripheral::CRAM>(RAM_Size, 0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), CBus::NStatus::OK);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Steps(4);
    EXPECT_EQ(cpu.Get_CPU_Context()[arm1176jzf_s::CCPU_Context::PC_Reg_Idx], 0x10);
}