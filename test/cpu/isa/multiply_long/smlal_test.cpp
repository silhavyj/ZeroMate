#include <gtest/gtest.h>

#include "cpu/arm1176jzf_s.hpp"

TEST(smlal_instruction, test_01)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00009 }, // mov r0, #0xFFFFFFF6
    { 0xe3e01009 }, // mov r1, #0xFFFFFFF6
    { 0xe0f32190 }  // smlals r2, r3, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0x00000064);
    EXPECT_EQ(cpu.m_regs[3], 0x0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(smlal_instruction, test_02)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00c02 }, // mvn r0, #512
    { 0xe3a01b01 }, // mov r1, #1024
    { 0xe0f32190 }  // smlals r2, r3, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0xFFF7FC00);
    EXPECT_EQ(cpu.m_regs[3], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(smlal_instruction, test_03)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00c02 }, // mov r0, #512
    { 0xe3a01b01 }, // mov r1, #1024
    { 0xe0f32190 }  // smlals r2, r3, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 512 * 1024);
    EXPECT_EQ(cpu.m_regs[3], 0x0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(smlal_instruction, test_04)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3a01b01 }, // mov r1, #1024
    { 0xe0f32190 }  // smlals r2, r3, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0);
    EXPECT_EQ(cpu.m_regs[3], 0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}