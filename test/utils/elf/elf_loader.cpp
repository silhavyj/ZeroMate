#include <gtest/gtest.h>

#include "peripherals/ram.hpp"
#include "arm1176jzf_s/core.hpp"
#include "utils/elf_loader.hpp"

static void Run_Test(const char* filename, std::uint32_t expected_value)
{
    static constexpr std::uint32_t RAM_SIZE = 1024 * 1024 * 256;

    auto ram = std::make_shared<zero_mate::peripheral::CRAM<RAM_SIZE>>();
    auto bus = std::make_shared<zero_mate::CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), 0);

    const auto [error_code, pc] = zero_mate::utils::elf::Load_Kernel(*bus, filename);
    EXPECT_EQ(error_code, zero_mate::utils::elf::NError_Code::OK);

    zero_mate::arm1176jzf_s::CCPU_Core cpu{ pc, bus };
    cpu.Run(0x1008);

    EXPECT_EQ(cpu.m_regs[0], expected_value);
}

TEST(elf_loader, test_01)
{
    Run_Test("../../../../test/utils/elf/source_files/test_01/kernel.elf", 2);
}

TEST(elf_loader, test_02)
{
    Run_Test("../../../../test/utils/elf/source_files/test_02/kernel.elf", 6);
}