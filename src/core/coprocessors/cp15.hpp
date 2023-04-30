#pragma once

#include <vector>
#include <unordered_map>

#include "coprocessor.hpp"

#include "../utils/logger/logger.hpp"

namespace zero_mate::coprocessor
{
    class CCP15 final : public ICoprocessor
    {
    public:
        static constexpr std::uint32_t ID = 15;

        enum class NPrimary_Register : std::uint32_t
        {
            ID_Codes = 0,
            Control_Register = 1
        };

        enum class NRegister_1 : std::uint32_t
        {
            Control_Register = 0b000,
            Auxiliary_Control_Register = 0b001,
            Coprocessor_Access_Control_Register = 0b010
        };

        static constexpr std::size_t REGISTER_1_COUNT = 3;

    public:
        explicit CCP15(arm1176jzf_s::CCPU_Context& cpu_context);

        void Perform_Register_Transfer(arm1176jzf_s::isa::CCoprocessor_Reg_Transfer instruction) override;
        void Perform_Data_Transfer(arm1176jzf_s::isa::CCoprocessor_Data_Transfer instruction) override;
        void Perform_Data_Operation(arm1176jzf_s::isa::CCoprocessor_Data_Operation instruction) override;

        [[nodiscard]] bool Is_Unaligned_Access_Permitted() const;

    private:
        inline void Initialize();

    private:
        std::unordered_map<NPrimary_Register, std::vector<std::uint32_t>> m_regs;
        utils::CLogging_System& m_logging_system;
    };
}