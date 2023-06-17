#include <gtest/gtest.h>

#include "zero_mate/utils/math.hpp"

TEST(lsr, uint32_test_01)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint32_t>(0b00010000'00000000'00000000'00000000U, 1U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00001000'00000000'00000000'00000000U);
}

TEST(lsr, uint32_test_02)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint32_t>(0b00010000'00000000'00000000'00000000U, 28U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000001U);
}

TEST(lsr, uint32_test_03)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint32_t>(0b00010000'00000000'00000000'00000000U, 29U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000000U);
}

TEST(lsr, uint32_test_04)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint32_t>(0b00010000'00000000'00000000'00000000U, 31U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000000U);
}

TEST(lsr, uint32_test_05)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint32_t>(271U, 0U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 271U);
}

TEST(lsr, uint32_test_06)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint32_t>(0b10000000'00000000'00000000'00000000U, 0U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b10000000'00000000'00000000'00000000U);
}

TEST(lsr, uint32_test_07)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint32_t>(0b01000000'00000000'00000000'00000000U, 0U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b01000000'00000000'00000000'00000000U);
}

TEST(lsr, uint8_test_01)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint8_t>(0b01000000, 0U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b01000000);
}

TEST(lsr, uint8_test_02)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint8_t>(0b10000000, 0U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b10000000);
}

TEST(lsr, uint8_test_03)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint8_t>(0b10000000, 7U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b1U);
}

TEST(lsr, uint8_test_04)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint8_t>(0b00010000, 2U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000100);
}

TEST(lsr, uint8_test_05)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSR<std::uint8_t>(0b01000000, 7U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b0U);
}