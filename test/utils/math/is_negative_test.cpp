#include <gtest/gtest.h>

#include "utils/math.hpp"

TEST(is_negative, uint32_test_01)
{
    using namespace zero_mate::utils::math;

    const std::uint32_t value{ 0b10000000'00000000'00000000'00000000 };

    EXPECT_EQ(Is_Negative<std::uint32_t>(value), true);
}

TEST(is_negative, uint32_test_02)
{
    using namespace zero_mate::utils::math;

    const std::uint32_t value{ 0b01111111'11111111'11111111'11111111 };

    EXPECT_EQ(Is_Negative<std::uint32_t>(value), false);
}

TEST(is_negative, uint8_test_01)
{
    using namespace zero_mate::utils::math;

    const std::uint8_t value{ 0b01111111 };

    EXPECT_EQ(Is_Negative<std::uint8_t>(value), false);
}

TEST(is_negative, uint8_test_02)
{
    using namespace zero_mate::utils::math;

    const std::uint8_t value{ 0b10000000 };

    EXPECT_EQ(Is_Negative<std::uint8_t>(value), true);
}

TEST(is_negative, uint64_uint32_test_01)
{
    using namespace zero_mate::utils::math;

    const std::uint64_t value{ 0b00000000'00000000'00000000'00000000'00000000'00000000'00000000'00000000 };
    const bool negative = Is_Negative<std::uint64_t, std::uint32_t>(value);

    EXPECT_EQ(negative, false);
}

TEST(is_negative, uint64_uint32_test_02)
{
    using namespace zero_mate::utils::math;

    const std::uint64_t value{ 0b00000000'00000000'00000000'00000000'10000000'00000000'00000000'00000000 };
    const bool negative = Is_Negative<std::uint64_t, std::uint32_t>(value);

    EXPECT_EQ(negative, true);
}

TEST(is_negative, uint64_uint32_test_03)
{
    using namespace zero_mate::utils::math;

    const std::uint64_t value{ 0b11111111'11111111'11111111'11111111'01111111'11111111'11111111'11111111 };
    const bool negative = Is_Negative<std::uint64_t, std::uint32_t>(value);

    EXPECT_EQ(negative, false);
}

TEST(is_negative, uint64_uint32_test_04)
{
    using namespace zero_mate::utils::math;

    const std::uint64_t value{ 0b11111111'11111111'11111111'11111111'11111111'11111111'11111111'11111111 };
    const bool negative = Is_Negative<std::uint64_t, std::uint32_t>(value);

    EXPECT_EQ(negative, true);
}

TEST(is_negative, uint32_uint8_test_01)
{
    using namespace zero_mate::utils::math;

    const std::uint32_t value{ 0b00000000'00000000'00000000'00000000 };
    const bool negative = Is_Negative<std::uint32_t, std::uint8_t>(value);

    EXPECT_EQ(negative, false);
}

TEST(is_negative, uint32_uint8_test_02)
{
    using namespace zero_mate::utils::math;

    const std::uint32_t value{ 0b00000000'00000000'00000000'10000000 };
    const bool negative = Is_Negative<std::uint32_t, std::uint8_t>(value);

    EXPECT_EQ(negative, true);
}