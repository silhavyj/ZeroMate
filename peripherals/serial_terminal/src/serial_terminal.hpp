#pragma once

#include <array>

#include <imgui.h>
#include <zero_mate/external_peripheral.hpp>

class CSerial_Terminal final : public zero_mate::IExternal_Peripheral
{
public:
    static constexpr std::uint32_t Clock_Rate = 250000000;

    static constexpr std::uint32_t Number_Of_Baud_Rate_Options = 8;
    static constexpr std::uint32_t Number_Of_Stop_Bit_Options = 2;
    static constexpr std::uint32_t Number_Of_Data_Length_Options = 2;

    static std::array<const char* const, Number_Of_Baud_Rate_Options> s_baud_rates;
    static std::array<const char* const, Number_Of_Stop_Bit_Options> s_stop_bits;
    static std::array<const char* const, Number_Of_Data_Length_Options> s_data_lengths;

    enum class NState_Machine
    {
        Start_Bit,
        Payload,
        Stop_Bit,
        End_Of_Frame
    };

public:
    explicit CSerial_Terminal(const std::string& name,
                              std::uint32_t pin_idx,
                              zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t read_pin,
                              zero_mate::utils::CLogging_System* logging_system);

    void Render() override;
    void Set_ImGui_Context(void* context) override;
    void GPIO_Subscription_Callback(std::uint32_t pin_idx) override;
    void Increment_Passed_Cycles(std::uint32_t count) override;

private:
    inline void Init_GPIO_Subscription();
    inline void Render_Settings();
    inline void Render_Baud_Rate();
    inline void Render_Stop_Bits();
    inline void Render_Data_Lengths();
    inline void Render_Data();
    inline void Render_Buttons();
    inline void Read_Payload();
    void Update();

private:
    std::string m_name;
    std::uint32_t m_pin_idx;
    zero_mate::IExternal_Peripheral::Read_GPIO_Pin_t m_read_pin;
    ImGuiContext* m_context;
    std::string m_data;
    int m_baud_rate_idx;
    std::uint32_t m_baud_rate;
    int m_stop_bits_idx;
    std::uint32_t m_stop_bits;
    int m_data_length_idx;
    std::uint32_t m_data_length;
    zero_mate::utils::CLogging_System* m_logging_system;
    std::uint32_t m_cpu_cycles;
    NState_Machine m_RX_state;
    std::uint32_t m_RX_bit_idx;
    std::string m_buffer;
    bool m_start_bit_detected;
};