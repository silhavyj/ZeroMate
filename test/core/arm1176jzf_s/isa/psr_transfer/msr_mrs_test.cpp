#include <gtest/gtest.h>
#include <fmt/core.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(psr_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe128f000 }  // msr cpsr_f, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPU_Mode(), CCPU_Context::NCPU_Mode::Supervisor);
    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPSR(), 0b11111111'00000000'00000000'11010011U);
}

TEST(psr_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::I), true);

    cpu.Execute({
    { 0xe10f0000 }, // mrs r0, cpsr
    { 0xe3c00080 }, // bic r0, r0, #0x80
    { 0xe121f000 }  // msr cpsr_c, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPU_Mode(), CCPU_Context::NCPU_Mode::Supervisor);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::I), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPSR(), 0b00000000'00000000'00000000'01010011U);
}

TEST(psr_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::I), true);

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe1a01280 }, // mov r1, r0, LSL #5
    { 0xe3811010 }, // orr r1, r1, #0b10000
    { 0xe129f001 }  // msr cpsr, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPU_Mode(), CCPU_Context::NCPU_Mode::User);
    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPSR(), 0xFF0000F0);
}

TEST(psr_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe10f0000 } // mrs r0, cpsr
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPSR(), 0b11010011U);
}

TEST(psr_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe14f0000 } // mrs r0, spsr
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Get_SPSR(), 0x0);
}

TEST(psr_instruction, test_06)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe10f0000 }, // mrs r0, cpsr
    { 0xe169f000 }  // msr spsr, r0
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Get_SPSR(), cpu.Get_CPU_Context()[0]);
}

TEST(psr_instruction, test_07)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe1a01280 }, // mov r1, r0, LSL #5
    { 0xe3811010 }, // orr r1, r1, #0b10000
    { 0xe169f001 }  // msr cpsr, r1
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPU_Mode(), CCPU_Context::NCPU_Mode::Supervisor);
    EXPECT_EQ(cpu.Get_CPU_Context().Get_SPSR(), 0xFF0000F0);
}

TEST(psr_instruction, test_08)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe321f0d2 } // msr cpsr_c, 0xd2
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPU_Mode(), CCPU_Context::NCPU_Mode::IRQ);
}

TEST(psr_instruction, test_09)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe328f205 } // msr cpsr_flg, #0x50000000
    });

    EXPECT_EQ(cpu.Get_CPU_Context().Get_CPU_Mode(), CCPU_Context::NCPU_Mode::Supervisor);

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}