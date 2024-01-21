#include <mutex>
#include <fstream>
#include <string_view>

#include "itm.hpp"

namespace itm
{
    CStream_Median::CStream_Median()
    : m_count{ 0 }
    {
    }

    void CStream_Median::Add_Number(double value)
    {
        ++m_count;

        if (m_max_heap.empty() || value <= m_max_heap.top())
        {
            m_max_heap.push(value);
        }
        else
        {
            m_min_heap.push(value);
        }

        if (m_max_heap.size() > m_min_heap.size() + 1)
        {
            m_min_heap.push(m_max_heap.top());
            m_max_heap.pop();
        }
        else if (m_min_heap.size() > m_max_heap.size())
        {
            m_max_heap.push(m_min_heap.top());
            m_min_heap.pop();
        }
    }

    double CStream_Median::Get_Median() const
    {
        if (m_max_heap.empty())
        {
            return 0.0;
        }

        if (m_max_heap.size() == m_min_heap.size())
        {
            return (m_max_heap.top() / 2.0) + (m_min_heap.top() / 2.0);
        }
        else
        {
            return m_max_heap.top();
        }
    }

    size_t CStream_Median::Get_Count() const
    {
        return m_count;
    }

    CJSON_File_Manager::CJSON_File_Manager(std::string_view filename)
    : m_file(filename.data(), std::ios::out | std::ios::trunc)
    {
        m_file << "{\"instructions\":[";
    }

    CJSON_File_Manager::~CJSON_File_Manager()
    {
        Flush_Records();
        m_file << "]}";
    }

    void CJSON_File_Manager::Flush_Records()
    {
        bool first{ true };

        for (const auto& [instruction_type, stream_median] : m_stats)
        {
            if (first)
            {
                first = false;
            }
            else
            {
                m_file << ",";
            }

            // clang-format off
            m_file << "{"
                       << R"("type":")" << instruction_type << "\","
                       << R"("time":)" << std::setprecision(2) << stream_median->Get_Median() << ","
                       << R"("count":)" << stream_median->Get_Count()
                   << "}";
            // clang-format on
        }
    }

    void CJSON_File_Manager::Add_Record(const TRecord& record)
    {
        const std::lock_guard<std::mutex> lock(m_mutex);

        if (!m_stats.contains(record.instruction_type))
        {
            m_stats[record.instruction_type] = std::make_unique<CStream_Median>();
        }

        m_stats[record.instruction_type]->Add_Number(static_cast<double>(record.execution_time));
    }
}
