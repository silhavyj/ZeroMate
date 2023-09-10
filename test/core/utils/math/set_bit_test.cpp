#include "gtest/gtest.h"

#include "zero_mate/utils/math.hpp"

TEST(set_bit, uint32_test_01)
{
    using namespace zero_mate::utils::math;

    std::uint32_t value{ 0b11111111'11111111'11111111'11111111 };
    Set_Bit<decltype(value)>(value, 31, false);

    EXPECT_EQ(value, 0b01111111'11111111'11111111'11111111U);
}

TEST(set_bit, uint32_test_02)
{
    using namespace zero_mate::utils::math;

    std::uint32_t value{ 0b11111111'11111111'11111111'11111111 };
    Set_Bit<decltype(value)>(value, 31, true);

    EXPECT_EQ(value, 0b11111111'11111111'11111111'11111111U);
}

TEST(set_bit, uint32_test_03)
{
    using namespace zero_mate::utils::math;

    std::uint32_t value{ 0b00000000'00000000'00000000'00000000 };
    Set_Bit<decltype(value)>(value, 0, true);

    EXPECT_EQ(value, 0b00000000'00000000'00000000'00000001U);
}

TEST(set_bit, uint32_test_04)
{
    using namespace zero_mate::utils::math;

    std::uint32_t value{ 0b00000000'00000000'00000000'00000000U };
    Set_Bit<decltype(value)>(value, 15, true);

    EXPECT_EQ(value, 0b00000000'00000000'10000000'00000000U);
}

TEST(set_bit, uint32_test_05)
{
    using namespace zero_mate::utils::math;

    std::uint32_t value{ 0b00000000'00000000'00000000'00000000U };
    Set_Bit<decltype(value)>(value, 15, true);

    EXPECT_EQ(value, 0b00000000'00000000'10000000'00000000U);
}

TEST(set_bit, uint8_test_01)
{
    using namespace zero_mate::utils::math;

    std::uint8_t value{ 0b00000000 };
    Set_Bit<decltype(value)>(value, 7, true);

    EXPECT_EQ(value, 0b10000000);
}

TEST(set_bit, uint8_test_02)
{
    using namespace zero_mate::utils::math;

    std::uint8_t value{ 0b00000000 };
    Set_Bit<decltype(value)>(value, 0, false);

    EXPECT_EQ(value, 0b00000000);
}

TEST(set_bit, uint8_test_03)
{
    using namespace zero_mate::utils::math;

    std::uint8_t value{ 0b11111111 };
    Set_Bit<decltype(value)>(value, 0, false);

    EXPECT_EQ(value, 0b11111110);
}

TEST(set_bit, uint8_test_04)
{
    using namespace zero_mate::utils::math;

    std::uint8_t value{ 0b11111111 };
    Set_Bit<decltype(value)>(value, 4, false);

    EXPECT_EQ(value, 0b11101111);
}