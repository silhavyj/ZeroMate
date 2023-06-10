#pragma once

#include <memory>

#include "../../window.hpp"
#include "../../../core/peripherals/monitor.hpp"

namespace zero_mate::gui
{
    class CMonitor_Window final : public IGUI_Window
    {
    public:
        explicit CMonitor_Window(const std::shared_ptr<peripheral::CMonitor>& monitor);

        void Render() override;

    private:
        const std::shared_ptr<peripheral::CMonitor>& m_monitor;
    };
}