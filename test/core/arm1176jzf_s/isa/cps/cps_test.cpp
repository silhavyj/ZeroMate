#include <gtest/gtest.h>
#include <fmt/format.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(cps_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xf10800c0 } // cpsie if
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::I), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::F), false);

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPU_Mode(), CCPU_Context::NCPU_Mode::Supervisor);

    cpu.Execute({
    { 0xf10c00c0 } // cpsid if
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::I), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::F), true);

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPU_Mode(), CCPU_Context::NCPU_Mode::Supervisor);
}

TEST(cps_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xf1020012 } // cps #0b10010
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::I), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::F), true);

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPU_Mode(), CCPU_Context::NCPU_Mode::IRQ);
}

TEST(cps_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xf10e0191 } // cpsid ai, #17
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::I), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::A), true);

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPU_Mode(), CCPU_Context::NCPU_Mode::FIQ);
}