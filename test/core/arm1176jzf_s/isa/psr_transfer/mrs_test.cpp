#include <gtest/gtest.h>

#include "core/arm1176jzf_s/core.hpp"

TEST(mrs_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe10f0000 } // mrs r0, cpsr
    });

    EXPECT_EQ(cpu.m_context.Get_CPSR(), 0b11010011);
}

TEST(mrs_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    CCPU_Core cpu{};

    cpu.Execute({
    { 0xe14f0000 } // mrs r0, spsr
    });

    EXPECT_EQ(cpu.m_context.Get_SPSR(), 0x0);
}