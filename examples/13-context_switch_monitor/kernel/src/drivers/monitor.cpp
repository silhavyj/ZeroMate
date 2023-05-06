#include <drivers/monitor.h>

CMonitor sMonitor{ 0x30000000, 80, 25 };

CMonitor::CMonitor(unsigned int monitor_base_addr, unsigned int width, unsigned int height)
: m_monitor{ reinterpret_cast<unsigned char*>(monitor_base_addr) }
, m_width{ width }
, m_height{ height }
, m_cursor{ 0, 0 }
, m_number_base{ DEFAULT_NUMBER_BASE }
{
}

void CMonitor::Reset_Cursor()
{
    m_cursor.y = 0;
    m_cursor.y = 0;
}

void CMonitor::Clear()
{
    Reset_Cursor();

    for (unsigned int y = 0; y < m_height; ++y)
    {
        for (unsigned int x = 0; x < m_width; ++x)
        {
            m_monitor[(y * m_width) + x] = ' ';
        }
    }
}

void CMonitor::Adjust_Cursor()
{
    if (m_cursor.x >= m_width)
    {
        m_cursor.x = 0;
        ++m_cursor.y;
    }

    if (m_cursor.y >= m_height)
    {
        Scroll();
        m_cursor.y = m_height - 1;
    }
}

void CMonitor::Scroll()
{
    for (unsigned int y = 1; y < m_height; ++y)
    {
        for (unsigned int x = 0; x < m_width; ++x)
        {
            m_monitor[((y - 1) * m_width) + x] = m_monitor[(y * m_width) + x];
        }
    }

    for (unsigned int x = 0; x < m_width; ++x)
    {
        m_monitor[((m_height - 1) * m_width) + x] = ' ';
    }
}

void CMonitor::Reset_Number_Base()
{
    m_number_base = DEFAULT_NUMBER_BASE;
}

CMonitor& CMonitor::operator<<(char c)
{
    if (c != '\n')
    {
        m_monitor[(m_cursor.y * m_width) + m_cursor.x] = static_cast<unsigned char>(c);
        ++m_cursor.x;
    }
    else
    {
        m_cursor.x = 0;
        ++m_cursor.y;
    }

    Adjust_Cursor();

    return *this;
}

CMonitor& CMonitor::operator<<(const char* str)
{
    for (unsigned int i = 0; str[i] != '\0'; ++i)
    {
        *this << str[i];
    }

    Reset_Number_Base();

    return *this;
}

CMonitor& CMonitor::operator<<(CMonitor::NNumber_Base number_base)
{
    m_number_base = number_base;

    return *this;
}

CMonitor& CMonitor::operator<<(unsigned int num)
{
    static constexpr unsigned int BUFFER_SIZE = 16;

    static char s_buffer[BUFFER_SIZE];

    itoa(num, s_buffer, static_cast<unsigned int>(m_number_base));
    *this << s_buffer;
    Reset_Number_Base();

    return *this;
}

CMonitor& CMonitor::operator<<(bool value)
{
    if (value)
    {
        *this << "true";
    }
    else
    {
        *this << "false";
    }

    Reset_Number_Base();

    return *this;
}

void CMonitor::itoa(unsigned int input, char* output, unsigned int base)
{
    int i = 0;

    while (input > 0)
    {
        output[i] = CharConvArr[input % base];
        input /= base;

        i++;
    }

    if (i == 0)
    {
        output[i] = CharConvArr[0];
        i++;
    }

    output[i] = '\0';
    i--;

    for (int j = 0; j <= (i / 2); j++)
    {
        char c = output[i - j];
        output[i - j] = output[j];
        output[j] = c;
    }
}
