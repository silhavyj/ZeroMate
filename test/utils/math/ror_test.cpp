#include <gtest/gtest.h>

#include "utils/math.hpp"

TEST(ror, uint32_test_01)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint32_t>(0b00000000'00000000'00000000'00000001U, 1U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b10000000'00000000'00000000'00000000U);
}

TEST(ror, uint32_test_02)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint32_t>(0b10000000'00000000'00000000'00000000U, 31U, false);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000001U);
}

TEST(ror, uint32_test_03)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint32_t>(0b11111111'00000000'11111111'00000000U, 8U, true);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000000'11111111'00000000'11111111);
}

TEST(ror, uint32_test_04)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint32_t>(0b11111111'00000000'00000000'11111111U, 8U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11111111'11111111'00000000'00000000U);
}

TEST(ror, uint32_test_05)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint32_t>(0b11111111'00000000'00000000'01111111U, 8U, false);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b01111111'11111111'00000000'00000000U);
}

TEST(ror, uint32_test_06)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint32_t>(0b11111111'00000000'00000000'01111111U, 0U, true);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11111111'10000000'00000000'00111111U);
}

TEST(ror, uint32_test_07)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint32_t>(0b11111111'00000000'00000000'01111111U, 0U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b01111111'10000000'00000000'00111111U);
}

TEST(ror, uint32_test_08)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint32_t>(0b00000000'00000000'00000000'00000000U, 0U, true);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b10000000'00000000'00000000'00000000U);
}

TEST(ror, uint32_test_09)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint32_t>(0b00000000'00000000'00000000'00000001U, 0U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000000U);
}

TEST(ror, uint8_test_01)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint8_t>(0b00000001U, 1U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b10000000U);
}

TEST(ror, uint8_test_02)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint8_t>(0b10000010U, 1U, false);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b01000001U);
}

TEST(ror, uint8_test_03)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint8_t>(0b11111111U, 7U, true);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11111111U);
}

TEST(ror, uint8_test_04)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint8_t>(0b11111110U, 7U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11111101U);
}

TEST(ror, uint8_test_05)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint8_t>(0b01111111U, 8U, true);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b01111111U);
}

TEST(ror, uint8_test_06)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint8_t>(0b00000000U, 0U, true);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b10000000);
}

TEST(ror, uint8_test_07)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint8_t>(0b00000001U, 0U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b00000000);
}

TEST(ror, uint8_test_08)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint8_t>(0b10000001U, 0U, true);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11000000);
}

TEST(ror, uint8_test_09)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ROR<std::uint8_t>(0b10000001U, 0U, false);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b01000000);
}