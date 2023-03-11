#include <gtest/gtest.h>

#include "peripherals/ram.hpp"
#include "arm1176jzf_s/core.hpp"

using namespace zero_mate;

static constexpr std::uint32_t RAM_SIZE = 1024;

TEST(fibonacci, non_recursive)
{
    // Non-recursive version - calculates fib(100)
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

    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>(0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Add_Breakpoint(0x8);
    cpu.Run();

    EXPECT_EQ(cpu.m_regs[0], -980107325);
}

TEST(fibonacci, recursive)
{
    // Calculates fib(10)
    // Note: The source code may be overwritten by the stack
    // causing unpredictable behavior (if x in fib(x) is set too high)

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

    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>(0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Add_Breakpoint(0x8);
    cpu.Run();

    EXPECT_EQ(cpu.m_regs[0], 55);
}

TEST(fibonacci, dynamic)
{
    // Calculates  fib(10) + fib(15) + fib(5);
    // Note: The source code may be overwritten by the stack
    // causing unpredictable behavior (if x in fib(x) is set too high)

    const std::vector<std::uint32_t> ram_content = {
        0xe3a0db01, 0xeb000038, 0xeafffffe, 0xe92d4810, 0xe28db008,
        0xe24dd00c, 0xe50b0010, 0xe50b1014, 0xe51b3010, 0xe3530001,
        0xca000007, 0xe51b3010, 0xe1a03103, 0xe51b2014, 0xe0823003,
        0xe51b2010, 0xe5832000, 0xe51b3010, 0xea000023, 0xe51b3010,
        0xe1a03103, 0xe51b2014, 0xe0823003, 0xe5933000, 0xe3730001,
        0x0a000005, 0xe51b3010, 0xe1a03103, 0xe51b2014, 0xe0823003,
        0xe5933000, 0xea000016, 0xe51b3010, 0xe2433001, 0xe51b1014,
        0xe1a00003, 0xebffffdd, 0xe1a04000, 0xe51b3010, 0xe2433002,
        0xe51b1014, 0xe1a00003, 0xebffffd7, 0xe1a01000, 0xe51b3010,
        0xe1a03103, 0xe51b2014, 0xe0823003, 0xe0842001, 0xe5832000,
        0xe51b3010, 0xe1a03103, 0xe51b2014, 0xe0823003, 0xe5933000,
        0xe1a00003, 0xe24bd008, 0xe8bd4810, 0xe12fff1e, 0xe92d4810,
        0xe28db008, 0xe24dd06c, 0xe3a03000, 0xe50b3010, 0xea000008,
        0xe51b3010, 0xe1a03103, 0xe24b200c, 0xe0823003, 0xe3e02000,
        0xe5032064, 0xe51b3010, 0xe2833001, 0xe50b3010, 0xe51b3010,
        0xe3530017, 0xdafffff3, 0xe24b3070, 0xe1a01003, 0xe3a0000a,
        0xebffffb1, 0xe1a04000, 0xe24b3070, 0xe1a01003, 0xe3a0000f,
        0xebffffac, 0xe1a03000, 0xe0844003, 0xe24b3070, 0xe1a01003,
        0xe3a00005, 0xebffffa6, 0xe1a03000, 0xe0843003, 0xe1a00003,
        0xe24bd008, 0xe8bd4810, 0xe12fff1e
    };

    auto ram = std::make_shared<peripheral::CRAM<RAM_SIZE>>(0, ram_content);
    auto bus = std::make_shared<CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    arm1176jzf_s::CCPU_Core cpu{ 0, bus };

    cpu.Add_Breakpoint(0x8);
    cpu.Run();

    EXPECT_EQ(cpu.m_regs[0], 670);
}