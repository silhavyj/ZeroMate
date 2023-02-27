#include <gtest/gtest.h>

#include "arm1176jzf_s/mocks/ram.hpp"
#include "arm1176jzf_s/core.hpp"

TEST(factorial, test_01)
{
    using namespace zero_mate::arm1176jzf_s;

    // Non-recursive version
    // Calculates 25! using the long long datatype and returns the result as a 32 signed integer
    const std::vector<std::uint32_t> ram_content = {
        0xe3a0db01, 0xeb000032, 0xeafffffe, 0xe92d0830, 0xe28db008,
        0xe24dd01c, 0xe50b0024, 0xe50b1020, 0xe3a02001, 0xe3a03000,
        0xe50b2014, 0xe50b3010, 0xe3a02002, 0xe3a03000, 0xe50b201c,
        0xe50b3018, 0xea000015, 0xe51b3010, 0xe51b201c, 0xe0020293,
        0xe51b3018, 0xe51b1014, 0xe0030391, 0xe0821003, 0xe51bc014,
        0xe51b001c, 0xe083209c, 0xe0811003, 0xe1a03001, 0xe50b2014,
        0xe50b3010, 0xe50b2014, 0xe50b3010, 0xe24b301c, 0xe893000c,
        0xe2924001, 0xe2a35000, 0xe50b401c, 0xe50b5018, 0xe24b101c,
        0xe8910003, 0xe24b3024, 0xe893000c, 0xe1500002, 0xe0d13003,
        0xbaffffe2, 0xe24b3014, 0xe893000c, 0xe1a00002, 0xe1a01003,
        0xe24bd008, 0xe8bd0830, 0xe12fff1e, 0xe92d4800, 0xe28db004,
        0xe3a00019, 0xe3a01000, 0xebffffc8, 0xe1a02000, 0xe1a03001,
        0xe1a03002, 0xe1a00003, 0xe24bd004, 0xe8bd4800, 0xe12fff1e
    };

    CCPU_Core cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };

    cpu.Run(0x8);

    EXPECT_EQ(cpu.m_regs[0], -775946240);
}

TEST(factorial, test_02)
{
    using namespace zero_mate::arm1176jzf_s;

    // Recursive version
    // Calculates 7! using the long long datatype and returns the result as a 32 signed integer
    const std::vector<std::uint32_t> ram_content = {
        0xe3a0db01, 0xeb000026, 0xeafffffe, 0xe92d4830, 0xe28db00c,
        0xe24dd008, 0xe50b0014, 0xe50b1010, 0xe24b3014, 0xe893000c,
        0xe3530000, 0x03520001, 0x1a000002, 0xe3a00001, 0xe3a01000,
        0xea000011, 0xe24b3014, 0xe893000c, 0xe2524001, 0xe2c35000,
        0xe1a00004, 0xe1a01005, 0xebffffeb, 0xe1a02000, 0xe1a03001,
        0xe51b1014, 0xe0000193, 0xe51b1010, 0xe0010192, 0xe080c001,
        0xe51be014, 0xe081029e, 0xe08c3001, 0xe1a01003, 0xe1a02000,
        0xe1a03001, 0xe1a00002, 0xe1a01003, 0xe24bd00c, 0xe8bd4830,
        0xe12fff1e, 0xe92d4800, 0xe28db004, 0xe3a00007, 0xe3a01000,
        0xebffffd4, 0xe1a02000, 0xe1a03001, 0xe1a03002, 0xe1a00003,
        0xe24bd004, 0xe8bd4800, 0xe12fff1e
    };

    CCPU_Core cpu{ 0, std::make_shared<mocks::CRAM>(0, ram_content) };

    cpu.Run(0x8);

    EXPECT_EQ(cpu.m_regs[0], 5040);
}