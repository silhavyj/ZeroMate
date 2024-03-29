#include "gtest/gtest.h"

#include "core/arm1176jzf_s/core.hpp"
#include "register_state_checker.hpp"

TEST(cmn_instruction, test_01)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<CCPU_Context> register_state_checker{};
    register_state_checker.Record_State(cpu.Get_CPU_Context());

    cpu.Execute({
    { 0xe3a000aa }, // mov r0, #170
    { 0xe3a01b02 }, // mov r1, #2048
    { 0xe1700001 }  // cmn r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.Get_CPU_Context(), { { .idx = 0, .expected_value = 170 },
                                     { .idx = 1, .expected_value = 2048 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(cmn_instruction, test_02)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<CCPU_Context> register_state_checker{};
    register_state_checker.Record_State(cpu.Get_CPU_Context());

    cpu.Execute({
    { 0xe3e00102 }, // mvn r0, #-2147483648
    { 0xe3a01001 }, // mov r1, #1
    { 0xe1700001 }  // cmn r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.Get_CPU_Context(), { { .idx = 0, .expected_value = 0x7FFFFFFF },
                            { .idx = 1, .expected_value = 1 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(cmn_instruction, test_03)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<CCPU_Context> register_state_checker{};
    register_state_checker.Record_State(cpu.Get_CPU_Context());

    cpu.Execute({
    { 0xe3a00102 }, // mov r0, #-2147483648
    { 0xe3e01000 }, // mov r1, #-1
    { 0xe1700001 }  // cmn r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.Get_CPU_Context(), { { .idx = 0, .expected_value = 0x80000000 },
                            { .idx = 1, .expected_value = static_cast<std::uint32_t>(-1) } }), false);
    // clang-format on

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), true);
}

TEST(cmn_instruction, test_04)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<CCPU_Context> register_state_checker{};
    register_state_checker.Record_State(cpu.Get_CPU_Context());

    cpu.Execute({
    { 0xe3a00000 }, // mov r0, #0
    { 0xe3a01000 }, // mov r1, #0
    { 0xe1700001 }  // cmn r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.Get_CPU_Context(), { { .idx = 0, .expected_value = 0 },
                            { .idx = 1, .expected_value = 0 } }), false);
    // clang-format on

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), true);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}

TEST(cmn_instruction, test_05)
{
    using namespace zero_mate::arm1176jzf_s;
    using namespace zero_mate::test;

    CCPU_Core cpu{};

    CRegister_State_Checker<CCPU_Context> register_state_checker{};
    register_state_checker.Record_State(cpu.Get_CPU_Context());

    cpu.Execute({
    { 0xe3a0300f }, // mov r3, #15
    { 0xe1a00283 }, // mov r0, r3, LSL #5
    { 0xe3a01000 }, // mov r1, #0
    { 0xe1700001 }  // cmn r0, r1
    });

    // clang-format off
    EXPECT_EQ(register_state_checker.Is_Any_Other_Register_Modified(
              cpu.Get_CPU_Context(), { { .idx = 3, .expected_value = 15 },
                            { .idx = 1, .expected_value = 0  },
                            { .idx = 0, .expected_value = (15U << 5U) } }), false);
    // clang-format on

    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::N), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::Z), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::C), false);
    EXPECT_EQ(cpu.Get_CPU_Context().Is_Flag_Set(CCPU_Context::NFlag::V), false);
}