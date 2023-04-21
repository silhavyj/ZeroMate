#pragma once

#include <mutex>
#include <memory>

namespace zero_mate::utils
{
    template<typename Type>
    class CSingleton
    {
    public:
        static Type* Get_Instance()
        {
            std::call_once(s_init_flag, [=]() -> void {
                CSingleton<Type>::s_instance = std::make_unique<Type>();
            });

            return s_instance.get();
        }

    private:
        static std::unique_ptr<Type> s_instance;
        static std::once_flag s_init_flag;
    };

    template<typename Type>
    std::unique_ptr<Type> CSingleton<Type>::s_instance{ nullptr };

    template<typename Type>
    std::once_flag CSingleton<Type>::s_init_flag{};
}