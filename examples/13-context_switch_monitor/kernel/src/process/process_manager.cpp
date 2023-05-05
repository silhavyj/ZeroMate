#include <process/process_manager.h>
#include <drivers/monitor.h>

#include <memory/kernel_heap.h>
#include <memory/pages.h>
#include <memory/memmap.h>

// "importovane" funkce z asm
extern "C"
{
    void process_bootstrap();
    void context_switch(TCPU_Context* ctx_to, TCPU_Context* ctx_from);
    void context_switch_first(TCPU_Context* ctx_to, TCPU_Context* ctx_from);
};

CProcess_Manager sProcessMgr;

CProcess_Manager::CProcess_Manager()
    : mLast_PID(0), mProcess_List_Head(nullptr), mCurrent_Task_Node(nullptr)
{
    //
}

TTask_Struct* CProcess_Manager::Get_Current_Process() const
{
    return mCurrent_Task_Node ? mCurrent_Task_Node->task : nullptr;
}

void CProcess_Manager::Create_Main_Process()
{
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();

    procnode->next = mProcess_List_Head;
    procnode->prev = nullptr;
    if (mProcess_List_Head == nullptr)
    {
        mProcess_List_Head = procnode;
    }
    mProcess_List_Head->prev = procnode;

    procnode->task = sKernelMem.Alloc<TTask_Struct>();

    auto* task = procnode->task;

    task->pid = ++mLast_PID;
    task->sched_static_priority = 5;
    task->sched_counter = task->sched_static_priority;
    task->state = NTask_State::Running;

    mCurrent_Task_Node = mProcess_List_Head;
}

uint32_t CProcess_Manager::Create_Process(unsigned long funcptr)
{
    CProcess_List_Node* procnode = sKernelMem.Alloc<CProcess_List_Node>();

    procnode->next = mProcess_List_Head;
    procnode->prev = nullptr;
    if (mProcess_List_Head != nullptr)
    {
        mProcess_List_Head->prev = procnode;
        mCurrent_Task_Node = mProcess_List_Head;
    }
    mProcess_List_Head = procnode;

    procnode->task = sKernelMem.Alloc<TTask_Struct>();

    auto* task = procnode->task;

    task->pid = ++mLast_PID;
    task->sched_static_priority = 5;
    task->sched_counter = task->sched_static_priority;
    task->state = NTask_State::New;
    
    task->cpu_context.lr = funcptr;
    task->cpu_context.pc = reinterpret_cast<unsigned long>(&process_bootstrap);
    task->cpu_context.sp = static_cast<unsigned long>(sPage_Manager.Alloc_Page()) + mem::PageSize;
    
    sMonitor << "0x" << CMonitor::NNumber_Base::HEX << (unsigned int)task->cpu_context.sp << '\n';

    return task->pid;
}

void CProcess_Manager::Schedule()
{
    CProcess_List_Node* next = mCurrent_Task_Node != nullptr ? mCurrent_Task_Node->next : mProcess_List_Head;
    if (next == nullptr)
    {
        next = mProcess_List_Head;
    }

    if (next == mCurrent_Task_Node)
    {
        mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
        return;
    }

    // sMonitor << "Next PID = " << next->task->pid << '\n';
    Switch_To(next);
}

void CProcess_Manager::Switch_To(CProcess_List_Node* node)
{
    // pokud je stavajici proces ve stavu Running (muze teoreticky byt jeste Blocked), vratime ho do stavu Runnable
    // Blocked prehazovat nebudeme ze zjevnych duvodu
    
    if (mCurrent_Task_Node->task->state == NTask_State::Running)
        mCurrent_Task_Node->task->state = NTask_State::Runnable;

    // projistotu vynulujeme prideleny pocet casovych kvant
    mCurrent_Task_Node->task->sched_counter = 0;

    TCPU_Context* old = &mCurrent_Task_Node->task->cpu_context;
    bool is_first_time = (node->task->state == NTask_State::New);

    // prehodime na novy proces, pridelime casova kvanta a nastavime proces do stavu Running
    mCurrent_Task_Node = node;
    mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
    mCurrent_Task_Node->task->state = NTask_State::Running;

    // pokud je to poprve, co je proces planovany, musime to vzit jeste pres malou odbocku ("bootstrap")
    if (is_first_time)
    {
        // sMonitor << "First context switch; pid = " << mCurrent_Task_Node->task->pid << "\n";
        context_switch_first(&node->task->cpu_context, old);
    }
    else
    {
        // sMonitor << "Normal context switch; pid = " << mCurrent_Task_Node->task->pid << "\n";
        context_switch(&node->task->cpu_context, old);
    }
}
