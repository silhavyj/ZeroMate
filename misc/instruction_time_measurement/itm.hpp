#pragma once

#include <mutex>
#include <chrono>
#include <fstream>
#include <memory>
#include <queue>
#include <vector>
#include <string_view>
#include <unordered_map>

namespace itm
{
    struct TRecord
    {
        std::string_view instruction_type;
        size_t execution_time;
    };

    class CStream_Median final
    {
    public:
        CStream_Median();

        void Add_Number(double value);
        [[nodiscard]] double Get_Median() const;
        [[nodiscard]] size_t Get_Count() const;

    private:
        std::priority_queue<double> m_max_heap;
        std::priority_queue<double, std::vector<double>, std::greater<>> m_min_heap;
        size_t m_count;
    };

    class CJSON_File_Manager final
    {
    public:
        explicit CJSON_File_Manager(std::string_view filename);
        ~CJSON_File_Manager();

        CJSON_File_Manager(const CJSON_File_Manager&) = delete;
        CJSON_File_Manager& operator=(const CJSON_File_Manager&) = delete;
        CJSON_File_Manager(CJSON_File_Manager&&) = delete;
        CJSON_File_Manager& operator=(CJSON_File_Manager&&) = delete;

        void Add_Record(const TRecord& record);

    private:
        void Flush_Records();

    private:
        std::ofstream m_file;
        std::mutex m_mutex;
        std::unordered_map<std::string_view, std::unique_ptr<CStream_Median>> m_stats;
    };

    template<typename Time_Precision = std::chrono::nanoseconds>
    class CInstruction_Timer final
    {
    private:
        using Timestamp_t = std::chrono::steady_clock::time_point;

    public:
        explicit CInstruction_Timer(std::string_view instruction_type, CJSON_File_Manager& file_manager);
        ~CInstruction_Timer();

        CInstruction_Timer(const CInstruction_Timer&) = delete;
        CInstruction_Timer& operator=(const CInstruction_Timer&) = delete;
        CInstruction_Timer(CInstruction_Timer&&) = delete;
        CInstruction_Timer& operator=(CInstruction_Timer&&) = delete;

    private:
        std::string_view m_instruction_type;
        CJSON_File_Manager& m_file_manager;
        Timestamp_t start;
    };

    template<typename Time_Precision>
    CInstruction_Timer<Time_Precision>::CInstruction_Timer(std::string_view instruction_type,
                                                           CJSON_File_Manager& file_manager)
    : m_instruction_type{ instruction_type }
    , m_file_manager{ file_manager }
    , start{ std::chrono::high_resolution_clock::now() }
    {
    }

    template<typename Time_Precision>
    CInstruction_Timer<Time_Precision>::~CInstruction_Timer()
    {
        const Timestamp_t end = std::chrono::high_resolution_clock::now();
        const auto duration = static_cast<size_t>(std::chrono::duration_cast<Time_Precision>(end - start).count());

        m_file_manager.Add_Record({ m_instruction_type, duration });
    }
}

#ifdef ITM_ENABLED
    #define ITM_FILE_MANAGER(filename) itm::CJSON_File_Manager file_manager(filename)
    #define ITM_INSTRUCTION_TIMER(instruction_type, file_manager) \
        const itm::CInstruction_Timer instruction_timer(instruction_type, file_manager)
#else
    #define ITM_FILE_MANAGER(filename)
    #define ITM_INSTRUCTION_TIMER(instruction_type, file_manager)
#endif
