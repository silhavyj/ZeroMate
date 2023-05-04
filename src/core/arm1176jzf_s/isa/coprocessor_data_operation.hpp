#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CCoprocessor_Data_Operation final : public CInstruction
    {
    public:
        explicit CCoprocessor_Data_Operation(CInstruction instruction) noexcept;

        [[nodiscard]] std::uint32_t Get_CP_OP_Code() const noexcept;
        [[nodiscard]] std::uint32_t Get_CRn() const noexcept;
        [[nodiscard]] std::uint32_t Get_CRd() const noexcept;
        [[nodiscard]] std::uint32_t Get_Coprocessor_ID() const noexcept;
        [[nodiscard]] std::uint32_t Get_Coprocessor_Information() const noexcept;
        [[nodiscard]] std::uint32_t Get_CRm() const noexcept;
    };
}