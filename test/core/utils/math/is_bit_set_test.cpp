#include <gtest/gtest.h>

#include "zero_mate/utils/math.hpp"

TEST(is_bit_set, uint32_test_01)
{
    using namespace zero_mate::utils::math;

    const std::uint32_t value{ 0b00000000'00000000'00000000'00000000 };

    EXPECT_EQ(Is_Bit_Set<std::uint32_t>(value, 31), false);
}

TEST(is_bit_set, uint32_test_02)
{
    using namespace zero_mate::utils::math;

    const std::uint32_t value{ 0b10000000'00000000'00000000'00000000 };

    EXPECT_EQ(Is_Bit_Set<std::uint32_t>(value, 31), true);
}

TEST(is_bit_set, uint32_test_03)
{
    using namespace zero_mate::utils::math;

    const std::uint32_t value{ 0b00000000'00000000'00000000'00000100 };

    EXPECT_EQ(Is_Bit_Set<decltype(value)>(value, 2), true);
}

TEST(is_bit_set, uint32_test_04)
{
    using namespace zero_mate::utils::math;

    const std::uint32_t value{ 0b00000000'00000000'00000000'00000001 };

    EXPECT_EQ(Is_Bit_Set<std::uint32_t>(value, 0), true);
}

TEST(is_bit_set, uint32_test_05)
{
    using namespace zero_mate::utils::math;

    const std::uint32_t value{ 0b00000000'00000000'00000000'00000000 };

    EXPECT_EQ(Is_Bit_Set<std::uint32_t>(value, 0), false);
}

TEST(is_bit_set, uint8_test_01)
{
    using namespace zero_mate::utils::math;

    const std::uint8_t value{ 0b10000000 };

    EXPECT_EQ(Is_Bit_Set<std::uint8_t>(value, 7), true);
}

TEST(is_bit_set, uint8_test_02)
{
    using namespace zero_mate::utils::math;

    const std::uint8_t value{ 0b00000000 };

    EXPECT_EQ(Is_Bit_Set<std::uint8_t>(value, 7), false);
}

TEST(is_bit_set, uint8_test_03)
{
    using namespace zero_mate::utils::math;

    const std::uint8_t value{ 0b00000001 };

    EXPECT_EQ(Is_Bit_Set<std::uint8_t>(value, 1), false);
}

TEST(is_bit_set, uint8_test_04)
{
    using namespace zero_mate::utils::math;

    const std::uint8_t value{ 0b00000001 };

    EXPECT_EQ(Is_Bit_Set<std::uint8_t>(value, 0), true);
}