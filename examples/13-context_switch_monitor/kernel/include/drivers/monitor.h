#pragma once

class CMonitor
{
public:
    enum class NNumber_Base : unsigned int
    {
        HEX = 16,
        DEC = 10
    };

    static constexpr auto DEFAULT_NUMBER_BASE = NNumber_Base::DEC;
    static constexpr const char* const CharConvArr = "0123456789ABCDEF";

public:
    explicit CMonitor(unsigned int monitor_base_addr, unsigned int width, unsigned int height);

    void Clear();

    CMonitor& operator<<(char c);
    CMonitor& operator<<(const char* str);
    CMonitor& operator<<(NNumber_Base number_base);
    CMonitor& operator<<(unsigned int num);
    CMonitor& operator<<(bool value);

private:
    inline void Adjust_Cursor();
    inline void Reset_Cursor();
    inline void Reset_Number_Base();

    void Scroll();

    void itoa(unsigned int input, char* output, unsigned int base);

private:
    struct TPosition
    {
        unsigned int y;
        unsigned int x;
    };

private:
    volatile unsigned char* const m_monitor;
    unsigned int m_width;
    unsigned int m_height;
    TPosition m_cursor;
    NNumber_Base m_number_base;
};

extern CMonitor sMonitor;
