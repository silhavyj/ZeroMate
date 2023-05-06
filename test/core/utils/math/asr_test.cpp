#include <gtest/gtest.h>

#include "core/utils/math.hpp"

TEST(asr, uint32_test_01)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b00100000'00000000'00000000'00000000U, 1U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00010000'00000000'00000000'00000000U);
}

TEST(asr, uint32_test_02)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b01000000'00000000'00000000'00000000U, 30U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000001U);
}

TEST(asr, uint32_test_03)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b00000000'00001000'00000000'00000000U, 4U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000000'00000000'10000000'00000000U);
}

TEST(asr, uint32_test_04)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b00000000'00000000'00000000'00000010U, 2U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000000U);
}

TEST(asr, uint32_test_05)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b00000000'00000000'00000000'00000010U, 3U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000000U);
}

TEST(asr, uint32_test_06)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b00000000'00000000'00000000'00000010U, 0U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b00000000'00000000'00000000'00000010U);
}

TEST(asr, uint32_test_07)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b01000000'00000000'00000000'00000000U, 0U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b01000000'00000000'00000000'00000000U);
}

TEST(asr, uint32_test_08)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b10000000'00000000'00000000'00000000U, 1U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b11000000'00000000'00000000'00000000U);
}

TEST(asr, uint32_test_09)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b10000000'00000000'00000000'00000001U, 1U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11000000'00000000'00000000'00000000U);
}

TEST(asr, uint32_test_10)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b10000000'00000000'00000000'00000001U, 0U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11111111'11111111'11111111'11111111U);
}

TEST(asr, uint32_test_11)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(0b10000000'00000000'00000000'00000000U, 0U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11111111'11111111'11111111'11111111U);
}

TEST(asr, uint32_test_12)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint32_t>(1U, 0U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 1U);
}

TEST(asr, uint8_test_01)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint8_t>(0b10000000U, 0U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11111111);
}

TEST(asr, uint8_test_02)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint8_t>(0b11111111U, 0U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11111111);
}

TEST(asr, uint8_test_03)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint8_t>(0b01111111U, 1U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b00111111U);
}

TEST(asr, uint8_test_04)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint8_t>(0b11111111U, 1U);

    EXPECT_EQ(carry_flag, true);
    EXPECT_EQ(result, 0b11111111U);
}

TEST(asr, uint8_test_05)
{
    using namespace zero_mate::utils::math;

    const auto [carry_flag, result] = ASR<std::uint8_t>(0b00100100U, 2U);

    EXPECT_EQ(carry_flag, false);
    EXPECT_EQ(result, 0b0001001U);
}