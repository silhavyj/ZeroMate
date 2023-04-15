#include <gtest/gtest.h>

#include "core/peripherals/ram.hpp"
#include "core/arm1176jzf_s/cpu_core.hpp"
#include "core/utils/elf_loader.hpp"

// #define ENABLE_ELF_TESTS

[[maybe_unused]] static void Run_Test(const char* filename, std::uint32_t expected_value)
{
    static constexpr std::uint32_t RAM_SIZE = 1024 * 1024 * 256;

    auto ram = std::make_shared<zero_mate::peripheral::CRAM>(RAM_SIZE);
    auto bus = std::make_shared<zero_mate::CBus>();

    EXPECT_EQ(bus->Attach_Peripheral(0x0, ram), zero_mate::CBus::NStatus::OK);

    const auto [error_code, pc, _] = zero_mate::utils::elf::Load_Kernel(*bus, filename);
    EXPECT_EQ(error_code, zero_mate::utils::elf::NError_Code::OK);

    zero_mate::arm1176jzf_s::CCPU_Core cpu{ pc, bus };

    cpu.Add_Breakpoint(0x1008);
    cpu.Run();

    EXPECT_EQ(cpu.m_regs[0], expected_value);
}

#ifdef ENABLE_ELF_TESTS

// These tests pass in an IDE. They fail in a CI pipeline
// due to an incorrect path to the .ELF files.

TEST(elf_loader, test_01)
{
    const std::string path = "../../../../test/core/utils/elf/source_files/test_01/kernel.elf";
    Run_Test(path.c_str(), 2);
}

TEST(elf_loader, test_02)
{
    const std::string path = "../../../../test/core/utils/elf/source_files/test_02/kernel.elf";
    Run_Test(path.c_str(), 6);
}

#endif