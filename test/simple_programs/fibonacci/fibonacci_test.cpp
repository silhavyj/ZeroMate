#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(fibonacci, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    // Non-recursive version
    const std::vector<std::uint32_t> ram_content = {
        0xe3a0db01, 0xeb000024, 0xeafffffe, 0xe52db004, 0xe28db000,
        0xe24dd01c, 0xe50b0018, 0xe3a03000, 0xe50b3008, 0xe3a03001,
        0xe50b300c, 0xe51b3018, 0xe3530000, 0x1a000001, 0xe51b3008,
        0xea000012, 0xe3a03002, 0xe50b3010, 0xea00000a, 0xe51b2008,
        0xe51b300c, 0xe0823003, 0xe50b3014, 0xe51b300c, 0xe50b3008,
        0xe51b3014, 0xe50b300c, 0xe51b3010, 0xe2833001, 0xe50b3010,
        0xe51b2010, 0xe51b3018, 0xe1520003, 0xdafffff0, 0xe51b300c,
        0xe1a00003, 0xe28bd000, 0xe49db004, 0xe12fff1e, 0xe92d4800,
        0xe28db004, 0xe3a00064, 0xebffffd7, 0xe1a03000, 0xe1a00003,
        0xe24bd004, 0xe8bd4800, 0xe12fff1e
    };

    CCPU_Core cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };

    cpu.Run(0x8);

    EXPECT_EQ(cpu.m_regs[0], -980107325);
}

TEST(fibonacci, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    // Recursive version
    // Caution: The source code may be overwritten by the stack
    // causing unpredictable behavior (if x in fib(x) was set too high)

    const std::vector<std::uint32_t> ram_content = {
        0xe3a0db01, 0xeb000018, 0xeafffffe, 0xe92d4810, 0xe28db008,
        0xe24dd00c, 0xe50b0010, 0xe51b3010, 0xe3530001, 0xca000001,
        0xe51b3010, 0xea00000a, 0xe51b3010, 0xe2433001, 0xe1a00003,
        0xebfffff2, 0xe1a04000, 0xe51b3010, 0xe2433002, 0xe1a00003,
        0xebffffed, 0xe1a03000, 0xe0843003, 0xe1a00003, 0xe24bd008,
        0xe8bd4810, 0xe12fff1e, 0xe92d4800, 0xe28db004, 0xe3a0000a,
        0xebffffe3, 0xe1a03000, 0xe1a00003, 0xe24bd004, 0xe8bd4800,
        0xe12fff1e
    };

    CCPU_Core cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };

    cpu.Run(0x8);

    EXPECT_EQ(cpu.m_regs[0], 55);
}