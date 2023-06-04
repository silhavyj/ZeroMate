#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(rsc_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a0500f }, // mov r5, #15
    { 0xe3a06010 }, // mov r6, #16
    { 0xe0f53006 }  // rscs r3, r5, r6
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(rsc_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a0500f }, // mov r5, #15
    { 0xe3a06010 }, // mov r6, #16
    { 0xe3d01102 }, // bics r1, r0, #0x80000000
    { 0xe0f53006 }  // rscs r3, r5, r6
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 1);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(rsc_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e01102 }, // mov r1, #0x7FFFFFFF
    { 0xe3e00000 }, // mov r0, #0xFFFFFFFF
    { 0xe3d02102 }, // bics r2, r0, #0x80000000
    { 0xe0f03001 }  // rscs r3, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x80000000);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(rsc_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e01102 }, // mov r1, #0x7FFFFFFF
    { 0xe3e00000 }, // mov r0, #0xFFFFFFFF
    { 0xe0f03001 }  // rscs r3, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x7FFFFFFF);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(rsc_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e01000 }, // mov r1, #0xFFFFFFFF
    { 0xe3e00102 }, // mov r0, #0x7FFFFFFF
    { 0xe0f03001 }  // rscs r3, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x7FFFFFFF);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(rsc_instruction, test_06)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #0x80000000
    { 0xe3a01001 }, // mov r1, #1
    { 0xe0f03001 }  // rscs r3, r0, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x80000000);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(rsc_instruction, test_07)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #0x80000000
    { 0xe3a01001 }, // mov r1, #1
    { 0xe0f13000 }  // rscs r3, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x7FFFFFFE);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(rsc_instruction, test_08)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a01102 }, // mov r1, #0x80000000
    { 0xe3a00001 }, // mov r0, #1
    { 0xe3d02102 }, // bics r2, r0, #0x80000000
    { 0xe0f13000 }  // rscs r3, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x80000001);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(rsc_instruction, test_09)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a01102 }, // mov r1, #0x80000000
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3d02102 }, // bics r2, r0, #0x80000000
    { 0xe0f13000 }  // rscs r3, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x80000000);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(rsc_instruction, test_10)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3a01102 }, // mov r1, #0x80000000
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3c02102 }, // bic r2, r0, #0x80000000
    { 0xe0f13000 }  // rscs r3, r1, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x7FFFFFFF);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(rsc_instruction, test_11)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00002 }, // mvn r0, #2
    { 0xe3e01000 }, // mvn r1, #0
    { 0xe0f027e1 }, // rscs r2, r0, r1, ror #15
    { 0xe07037e1 }  // rsbs r3, r0, r1, ror #15
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x1);
    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x2);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(rsc_instruction, test_12)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e01002 }, // mvn r1, #2
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe0f027a1 }, // rscs r2, r0, r1, lsr #15
    { 0xe07037a1 }  // rsbs r3, r0, r1, lsr #15
    });

    EXPECT_EQ(cpu.Get_CPU_Context()[2], 0x1FFFF);
    EXPECT_EQ(cpu.Get_CPU_Context()[3], 0x20000);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}