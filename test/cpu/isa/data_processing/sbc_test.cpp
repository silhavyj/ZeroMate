#include <gtest/gtest.h>

#include "cpu/ARM1176JZF_S.hpp"

TEST(sbc_instruction, test_01)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a0600f }, // mov r6, #15
    { 0xe3a05010 }, // mov r5, #16
    { 0xe0d53006 }  // sbcs r3, r5, r6
    });

    EXPECT_EQ(cpu.m_regs[3], 0);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(sbc_instruction, test_02)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a05010 }, // mov r5, #15
    { 0xe3a0600f }, // mov r6, #16
    { 0xe3d01102 }, // bics r1, r0, #0x80000000
    { 0xe0d53006 }  // sbcs r3, r5, r6
    });

    EXPECT_EQ(cpu.m_regs[3], 1);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(sbc_instruction, test_03)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00102 }, // mov r0, #0x7FFFFFFF
    { 0xe3e01000 }, // mov r1, #0xFFFFFFFF
    { 0xe3d02102 }, // bics r2, r0, #0x80000000
    { 0xe0d03001 }  // sbcs r3, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[3], 0x80000000);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), true);
}

TEST(sbc_instruction, test_04)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00102 }, // mov r0, #0x7FFFFFFF
    { 0xe3e01000 }, // mov r1, #0xFFFFFFFF
    { 0xe0d03001 }  // sbcs r3, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[3], 0x7FFFFFFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(sbc_instruction, test_05)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mov r0, #0xFFFFFFFF
    { 0xe3e01102 }, // mov r1, #0x7FFFFFFF
    { 0xe0d03001 }  // sbcs r3, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[3], 0x7FFFFFFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), true);
}

TEST(sbc_instruction, test_06)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a01102 }, // mov r1, #0x80000000
    { 0xe3a00001 }, // mov r0, #1
    { 0xe0d03001 }  // sbcs r3, r0, r1
    });

    EXPECT_EQ(cpu.m_regs[3], 0x80000000);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), true);
}

TEST(sbc_instruction, test_07)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a01102 }, // mov r1, #0x80000000
    { 0xe3a00001 }, // mov r0, #1
    { 0xe0d23001 }  // sbcs r3, r2, r1
    });

    EXPECT_EQ(cpu.m_regs[3], 0x7FFFFFFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(sbc_instruction, test_08)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #0x80000000
    { 0xe3a01001 }, // mov r1, #1
    { 0xe3d02102 }, // bics r2, r0, #0x80000000
    { 0xe0d23001 }  // sbcs r3, r2, r1
    });

    EXPECT_EQ(cpu.m_regs[3], 0xFFFFFFFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(sbc_instruction, test_09)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #0x80000000
    { 0xe3a01000 }, // mov r1, #0
    { 0xe3d02102 }, // bics r2, r0, #0x80000000
    { 0xe0d13000 }  // sbcs r3, r1, r0
    });

    EXPECT_EQ(cpu.m_regs[3], 0x80000000);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), true);
}

TEST(sbc_instruction, test_10)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #0x80000000
    { 0xe3a01000 }, // mov r1, #0
    { 0xe3c02102 }, // bic r2, r0, #0x80000000
    { 0xe0d13000 }  // sbcs r3, r1, r0
    });

    EXPECT_EQ(cpu.m_regs[3], 0x7FFFFFFF);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(sbc_instruction, test_11)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e01002 }, // mvn r1, #2
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe0d027e1 }, // sbcs r2, r0, r1, ror #15
    { 0xe05037e1 }  // subs r3, r0, r1, ror #15
    });

    EXPECT_EQ(cpu.m_regs[2], 0x3FFFF);
    EXPECT_EQ(cpu.m_regs[3], 0x40000);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}

TEST(sbc_instruction, test_12)
{
    using namespace zero_mate::cpu;

    CARM1176JZF_S cpu{};

    cpu.Execute({
    { 0xe3e00002 }, // mvn r0, #2
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe0d027a1 }, // sbcs r2, r0, r1, lsr #15
    { 0xe05037a1 }  // subs r3, r0, r1, lsr #15
    });

    EXPECT_EQ(cpu.m_regs[2], 0xFFFDFFFD);
    EXPECT_EQ(cpu.m_regs[3], 0xFFFDFFFE);

    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::N), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::Z), false);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::C), true);
    EXPECT_EQ(cpu.m_cspr.Is_Flag_Set(CCSPR::NFlag::V), false);
}