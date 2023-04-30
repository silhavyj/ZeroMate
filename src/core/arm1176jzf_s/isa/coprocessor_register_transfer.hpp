#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CCoprocessor_Reg_Transfer final : public CInstruction
    {
    public:
        explicit CCoprocessor_Reg_Transfer(CInstruction instruction) noexcept;

        [[nodiscard]] std::uint32_t Get_Opcode1() const noexcept;
        [[nodiscard]] bool Is_L_Bit_Set() const noexcept;
        [[nodiscard]] std::uint32_t Get_CRn() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rd() const noexcept;
        [[nodiscard]] std::uint32_t Get_Coprocessor_ID() const noexcept;
        [[nodiscard]] std::uint32_t Get_Opcode2() const noexcept;
        [[nodiscard]] std::uint32_t Get_CRm() const noexcept;
    };
}