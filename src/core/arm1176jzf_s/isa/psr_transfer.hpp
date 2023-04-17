#pragma once

#include "instruction.hpp"

namespace zero_mate::arm1176jzf_s::isa
{
    class CPSR_Transfer final : public CInstruction
    {
    public:
        enum class NRegister : std::uint32_t
        {
            CPSR = 0,
            SPSR = 1
        };

        enum class NType : std::uint32_t
        {
            MRS = 0,
            MSR = 1
        };

        explicit CPSR_Transfer(CInstruction instruction) noexcept;

        [[nodiscard]] NRegister Get_Register_Type() const noexcept;
        [[nodiscard]] NType Get_Type() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rm() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rd() const noexcept;
        [[nodiscard]] std::uint32_t Get_Mask() const noexcept;
        [[nodiscard]] bool Is_Immediate() const noexcept;
        [[nodiscard]] std::uint32_t Get_Rotate() const noexcept;
        [[nodiscard]] std::uint32_t Get_Immediate() const noexcept;

    private:
        [[nodiscard]] inline bool Is_F_Bit_Set() const noexcept;
        [[nodiscard]] inline bool Is_S_Bit_Set() const noexcept;
        [[nodiscard]] inline bool Is_X_Bit_Set() const noexcept;
        [[nodiscard]] inline bool Is_C_Bit_Set() const noexcept;
    };
}