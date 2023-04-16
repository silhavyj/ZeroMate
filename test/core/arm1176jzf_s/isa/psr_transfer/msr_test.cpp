#include <gtest/gtest.h>
#include <fmt/core.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(msr_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe128f000 }  // msr cpsr_f, r0
    });

    EXPECT_EQ(cpu.m_context.Get_CPU_Mode(), CCPU_Context::NCPU_Mode::Supervisor);
    EXPECT_EQ(cpu.m_context.Get_CPSR(), 0b11111111'00000000'00000000'11010011U);
}

TEST(msr_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::I), true);

    cpu.Execute({
    { 0xe10f0000 }, // mrs r0, cpsr
    { 0xe3c00080 }, // bic r0, r0, #0x80
    { 0xe121f000 }  // msr cpsr_c, r0
    });

    EXPECT_EQ(cpu.m_context.Get_CPU_Mode(), CCPU_Context::NCPU_Mode::Supervisor);
    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::I), false);
    EXPECT_EQ(cpu.m_context.Get_CPSR(), 0b00000000'00000000'00000000'01010011U);
}

TEST(msr_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    EXPECT_EQ(cpu.m_context.Is_Flag_Set(CCPU_Context::NFlag::I), true);

    cpu.Execute({
    { 0xe3e00000 }, // mvn r0, #0
    { 0xe1a01280 }, // mov r1, r0, LSL #5
    { 0xe3811010 }, // orr r1, r1, #0b10000
    { 0xe129f001 }  // msr cpsr, r1
    });

    EXPECT_EQ(cpu.m_context.Get_CPU_Mode(), CCPU_Context::NCPU_Mode::User);
    EXPECT_EQ(cpu.m_context.Get_CPSR(), 0xFF0000F0);
}

