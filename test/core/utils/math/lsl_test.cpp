#include "gtest/gtest.h"

#include "zero_mate/utils/math.hpp"

TEST(lsl, uint32_test_01)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint32_t>(0b00010000'00000000'00000000'00000000U, 1U, false);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00100000'00000000'00000000'00000000U);
}

TEST(lsl, uint32_test_02)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint32_t>(0b00010000'00000000'00000000'00000000U, 3U, false);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b10000000'00000000'00000000'00000000U);
}

TEST(lsl, uint32_test_03)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint32_t>(0b00000000'00000000'00000000'00000001U, 31U, false);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b10000000'00000000'00000000'00000000U);
}

TEST(lsl, uint32_test_04)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint32_t>(0b00010000'00000000'00000000'00000000U, 4U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000000U);
}

TEST(lsl, uint32_test_05)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint32_t>(0b01000000'00000000'00000000'00000000U, 20U, false);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000000U);
}

TEST(lsl, uint32_test_06)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint32_t>(155U, 0U, false);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 155U);
}

TEST(lsl, uint32_test_07)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint32_t>(155U, 0U, true);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 155U);
}

TEST(lsl, uint32_test_08)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint32_t>(0b1U, 1U, true);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b10U);
}

TEST(lsl, uint32_test_09)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint32_t>(0b1U << 31U, 1U, true);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b0U);
}

TEST(lsl, uint8_test_01)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint8_t>(0b10000000U, 1U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b00000000U);
}

TEST(lsl, uint8_test_02)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint8_t>(0b00000000U, 1U, true);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000000U);
}

TEST(lsl, uint8_test_03)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint8_t>(0b00000001U, 7U, false);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b10000000U);
}

TEST(lsl, uint8_test_04)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint8_t>(0b00000010U, 7U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b00000000U);
}

TEST(lsl, uint8_test_05)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint8_t>(0b00000010U, 0U, false);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000010U);
}

TEST(lsl, uint8_test_06)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = LSL<std::uint8_t>(0b00000010U, 0U, true);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b00000010U);
}