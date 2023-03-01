#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(swp_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    auto ram = std::make_shared<mocks::CRAM>();
    CCPU_Core cpu{ 0, ram };

    cpu.Execute({
    { 0xe3a020c8 }, // mov r2, #200
    { 0xe3a01021 }, // mov r1, #33
    { 0xe5821000 }, // str r1, [r2]
    { 0xe3a0104f }, // mov r1, #79
    { 0xe1020091 }  // swp r0, r1, [r2]
    });

    EXPECT_EQ(ram->Read<std::uint32_t>(200), 79);

    EXPECT_EQ(cpu.m_regs[0], 33);
}