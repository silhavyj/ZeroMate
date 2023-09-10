#include <memory>

#include "gtest/gtest.h"

#include "core/arm1176jzf_s/core.hpp"

using namespace zero_mate;

TEST(enable_coprocessor_access, test_01)
{
    arm1176jzf_s::CCPU_Core cpu{};
    const auto cp15 = std::make_shared<coprocessor::cp15::CCP15>(cpu.Get_CPU_Context());

    cpu.Add_Coprocessor(coprocessor::cp15::CCP15::ID, cp15);

    const auto cp15_c1 = cp15->Get_Primary_Register<coprocessor::cp15::CC1>(coprocessor::cp15::NPrimary_Register::C1);
    EXPECT_EQ(cp15_c1->Get_Coprocessor_Access_Type(10), coprocessor::cp15::CC1::NCoprocessor_Access_Type::Access_Denied);
    EXPECT_EQ(cp15_c1->Get_Coprocessor_Access_Type(11), coprocessor::cp15::CC1::NCoprocessor_Access_Type::Access_Denied);

    cpu.Execute({
    { 0xee110f50 }, // mrc p15, 0, r0, c1, c0, 2
    { 0xe3800603 }, // orr r0, r0, #0x300000
    { 0xee010f50 }  // mcr p15, 0, r0, c1, c0, 2
    });

    EXPECT_EQ(cp15_c1->Get_Coprocessor_Access_Type(10), coprocessor::cp15::CC1::NCoprocessor_Access_Type::Privileged_And_User_Mode_Access);
    EXPECT_EQ(cp15_c1->Get_Coprocessor_Access_Type(11), coprocessor::cp15::CC1::NCoprocessor_Access_Type::Access_Denied);
}

TEST(enable_coprocessor_access, test_02)
{
    arm1176jzf_s::CCPU_Core cpu{};
    const auto cp15 = std::make_shared<coprocessor::cp15::CCP15>(cpu.Get_CPU_Context());

    cpu.Add_Coprocessor(coprocessor::cp15::CCP15::ID, cp15);

    const auto cp15_c1 = cp15->Get_Primary_Register<coprocessor::cp15::CC1>(coprocessor::cp15::NPrimary_Register::C1);
    EXPECT_EQ(cp15_c1->Get_Coprocessor_Access_Type(11), coprocessor::cp15::CC1::NCoprocessor_Access_Type::Access_Denied);
    EXPECT_EQ(cp15_c1->Get_Coprocessor_Access_Type(10), coprocessor::cp15::CC1::NCoprocessor_Access_Type::Access_Denied);

    cpu.Execute({
    { 0xee110f50 }, // mrc p15, 0, r0, c1, c0, 2
    { 0xe3800503 }, // orr r0, r0, #0xC00000
    { 0xee010f50 }  // mcr p15, 0, r0, c1, c0, 2
    });

    EXPECT_EQ(cp15_c1->Get_Coprocessor_Access_Type(11), coprocessor::cp15::CC1::NCoprocessor_Access_Type::Privileged_And_User_Mode_Access);
    EXPECT_EQ(cp15_c1->Get_Coprocessor_Access_Type(10), coprocessor::cp15::CC1::NCoprocessor_Access_Type::Access_Denied);
}