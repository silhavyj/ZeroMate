#include <gtest/gtest.h>

#include "arm1176jzf_s/core.hpp"

TEST(mov_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a0d902 }, // mov sp, #0x8000
    { 0xe3a03080 }  // mov r3, #0b10000000
    });

    EXPECT_EQ(cpu.m_regs[13], 0x8000);
    EXPECT_EQ(cpu.m_regs[3], 0b10000000);
}

TEST(mov_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a0009b }, // mov r0, #155
    { 0xe1a01000 }  // mov r1, r0
    });

    EXPECT_EQ(cpu.m_regs[0], 155);
    EXPECT_EQ(cpu.m_regs[1], 155);
}

TEST(mov_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3b00000 }, // movs r0, #0
    { 0xe3a01b01 }  // mov r1, #1024
    });

    EXPECT_EQ(cpu.m_regs[0], 0);
    EXPECT_EQ(cpu.m_regs[1], 1024);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);

    cpu.Execute({
    { 0x01b02001 } // moveqs r2, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 1024);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
}

TEST(mov_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3b00001 }, // movs r0, #1
    { 0xe3a01b01 }, // mov r1, #1024
    { 0x01a02001 }  // moveq r2, r1
    });

    EXPECT_EQ(cpu.m_regs[0], 1);
    EXPECT_EQ(cpu.m_regs[1], 1024);
    EXPECT_EQ(cpu.m_regs[2], 0);
}

TEST(mov_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3b00000 } // movs r0, #0
    });

    EXPECT_EQ(cpu.m_regs[0], 0);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);

    cpu.Execute({
    { 0xe3b01b01 } // movs r1, #1024
    });

    EXPECT_EQ(cpu.m_regs[1], 1024);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);

    cpu.Execute({
    { 0x01a02001 } // moveq r2, r1
    });

    EXPECT_EQ(cpu.m_regs[2], 0);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
}

TEST(mov_instruction, test_06)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a03005 }, // mov r3, #5 (r3 = 5)
    { 0xe3a01001 }, // mov r1, #1 (r1 = 1)
    { 0xe1b00311 }  // movs r0, r1, LSL r3 (r0 = r1 << r3)
    });

    EXPECT_EQ(cpu.m_regs[0], 32);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(mov_instruction, test_07)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.m_regs[3] = 0b11111111'1111111'1111111'00001000;

    cpu.Execute({
    { 0xe3a01001 }, // mov r1, #1 (r1 = 1)
    { 0xe1b00311 }  // movs r0, r1, LSL r3 (r0 = r1 << (r3 & 0xFF))
    });

    EXPECT_EQ(cpu.m_regs[0], 256);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(mov_instruction, test_08)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.m_regs[3] = 31;

    cpu.Execute({
    { 0xe3a01001 }, // mov r1, #1 (r1 = 1)
    { 0xe1b00311 }  // movs r0, r1, LSL r3 (r0 = r1 << (r3 & 0xFF))
    });

    EXPECT_EQ(cpu.m_regs[0], 0x80000000);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(mov_instruction, test_09)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.m_regs[1] = 5;

    cpu.Execute({
    { 0xe1b020a1 } // movs r2, r1, LSR #1
    });

    EXPECT_EQ(cpu.m_regs[2], 2);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(mov_instruction, test_10)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.m_regs[1] = 0x80000000;

    cpu.Execute({
    { 0xe1b02fa1 } // movs r2, r1, LSR #31
    });

    EXPECT_EQ(cpu.m_regs[2], 1);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(mov_instruction, test_11)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.m_regs[1] = 0x80000000 >> 1;

    cpu.Execute({
    { 0xe1b02fa1 } // movs r2, r1, LSR #31
    });

    EXPECT_EQ(cpu.m_regs[2], 0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);

    cpu.Execute({
    { 0xe3a01005 }, // mov r1, #5
    { 0x21b021e1 }  // movhss r2, r1, ROR #3
    });

    EXPECT_EQ(cpu.m_regs[2], 0b10100000'00000000'00000000'00000000);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}