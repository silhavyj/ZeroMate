#include <memory>

#include "gtest/gtest.h"

#include "core/bus.hpp"
#include "core/peripherals/peripheral.hpp"

using namespace zero_mate;

class CPeripheral_Mock : public peripheral::IPeripheral
{
public:
    explicit CPeripheral_Mock(std::uint32_t size) noexcept
    : m_size{ size }
    {
    }

    void Reset() noexcept override
    {
    }

    [[nodiscard]] std::uint32_t Get_Size() const noexcept override
    {
        return m_size;
    }

    void Write([[maybe_unused]] std::uint32_t addr,
               [[maybe_unused]] const char* data,
               [[maybe_unused]] std::uint32_t size) override
    {
    }

    void Read([[maybe_unused]] std::uint32_t addr,
              [[maybe_unused]] char* data,
              [[maybe_unused]] std::uint32_t size) override
    {
    }

private:
    std::uint32_t m_size;
};

TEST(attach_peripheral, test_01)
{
    auto bus = std::make_shared<CBus>();

    auto p1 = std::make_shared<CPeripheral_Mock>(1);
    auto p2 = std::make_shared<CPeripheral_Mock>(1);

    EXPECT_EQ(bus->Attach_Peripheral(0, p1), CBus::NStatus::OK);
    EXPECT_EQ(bus->Attach_Peripheral(1, p1), CBus::NStatus::OK);
}

TEST(attach_peripheral, test_02)
{
    auto bus = std::make_shared<CBus>();

    auto p1 = std::make_shared<CPeripheral_Mock>(2);
    auto p2 = std::make_shared<CPeripheral_Mock>(2);

    EXPECT_EQ(bus->Attach_Peripheral(0, p1), CBus::NStatus::OK);
    EXPECT_EQ(bus->Attach_Peripheral(1, p1), CBus::NStatus::Addr_Collision);
}

TEST(attach_peripheral, test_03)
{
    auto bus = std::make_shared<CBus>();

    auto p1 = std::make_shared<CPeripheral_Mock>(2);
    auto p2 = std::make_shared<CPeripheral_Mock>(2);

    EXPECT_EQ(bus->Attach_Peripheral(0, p1), CBus::NStatus::OK);
    EXPECT_EQ(bus->Attach_Peripheral(0xFFFFFFFF - 2, p1), CBus::NStatus::OK);
}

TEST(attach_peripheral, test_04)
{
    auto bus = std::make_shared<CBus>();

    auto p1 = std::make_shared<CPeripheral_Mock>(2);
    auto p2 = std::make_shared<CPeripheral_Mock>(2);

    EXPECT_EQ(bus->Attach_Peripheral(0, p1), CBus::NStatus::OK);
    EXPECT_EQ(bus->Attach_Peripheral(0xFFFFFFFF - 1, p1), CBus::NStatus::Out_Of_Addr_Space);
}

TEST(attach_peripheral, test_05)
{
    auto bus = std::make_shared<CBus>();

    auto p1 = std::make_shared<CPeripheral_Mock>(2);
    auto p2 = std::make_shared<CPeripheral_Mock>(2);
    auto p3 = std::make_shared<CPeripheral_Mock>(3);

    EXPECT_EQ(bus->Attach_Peripheral(0, p1), CBus::NStatus::OK);
    EXPECT_EQ(bus->Attach_Peripheral(5, p2), CBus::NStatus::OK);
    EXPECT_EQ(bus->Attach_Peripheral(2, p3), CBus::NStatus::OK);
}

TEST(attach_peripheral, test_06)
{
    auto bus = std::make_shared<CBus>();

    auto p1 = std::make_shared<CPeripheral_Mock>(2);
    auto p2 = std::make_shared<CPeripheral_Mock>(2);
    auto p3 = std::make_shared<CPeripheral_Mock>(3);

    EXPECT_EQ(bus->Attach_Peripheral(0, p1), CBus::NStatus::OK);
    EXPECT_EQ(bus->Attach_Peripheral(5, p2), CBus::NStatus::OK);
    EXPECT_EQ(bus->Attach_Peripheral(3, p3), CBus::NStatus::Addr_Collision);
}