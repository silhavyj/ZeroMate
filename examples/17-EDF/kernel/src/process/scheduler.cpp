#include <process/process_manager.h>

CProcess_List_Node* CProcess_Manager::Schedule_RR()
{
    // je nejaky proces naplanovany? pokud je ve stavu running, budeme snizovat citac, pokud ne, musime okamzite
    // preplanovat
    if (mCurrent_Task_Node && mCurrent_Task_Node->task->state == NTask_State::Running)
    {
        // snizime citac planovace
        mCurrent_Task_Node->task->sched_counter--;
        // pokud je citac vetsi nez 0, zatim nebudeme preplanovavat (a zaroven je proces stale ve stavu Running -
        // nezablokoval se nad necim)
        if (mCurrent_Task_Node->task->sched_counter > 0)
            return nullptr;
    }

    // najdeme dalsi proces na planovani

    // vybereme dalsi proces v rade
    CProcess_List_Node* next = mCurrent_Task_Node ? mCurrent_Task_Node->next : mProcess_List_Head;
    if (!next)
        next = mProcess_List_Head;

    // proces k naplanovani musi bud byt ve stavu runnable (jiz nekdy bezel a muze bezet znovu) nebo running (pak jde o
    // stavajici proces) a nebo new (novy proces, ktery jeste nebyl planovany)
    while (next->task->state != NTask_State::Runnable && next->task->state != NTask_State::Running &&
           next->task->state != NTask_State::New)
    {
        if (!next)
        {
            next = mCurrent_Task_Node;
            break;
        }
        else
            next = next->next;
    }

    // pokud nechceme preplanovavat soucasny proces...
    if (next == mCurrent_Task_Node)
    {
        // pokud by se mel preplanovat kvuli vyprseni casovych kvant...
        if (mCurrent_Task_Node->task->sched_counter == 0)
        {
            // nastavime mu zase zpatky jeho pridel casovych kvant a vracime se
            mCurrent_Task_Node->task->sched_counter = mCurrent_Task_Node->task->sched_static_priority;
        }
    }

    return next;
}

CProcess_List_Node* CProcess_Manager::Schedule_EDF()
{
    CProcess_List_Node* next = nullptr;

    // EDF = najdeme takovy proces, ktery je ve stavu Running nebo Runnable a ma deadline nejblizsi aktualni casove
    // znacce

    CProcess_List_Node* itr = mProcess_List_Head;
    while (itr)
    {
        // potrebujeme, aby proces byl planovatelny (novy, bezici nebo runnable)
        if (itr->task->state != NTask_State::New && itr->task->state != NTask_State::Runnable &&
            itr->task->state != NTask_State::Running)
        {
            itr = itr->next;
            continue;
        }

        // "v nejhorsim" naplanujeme i takovy proces, ktery nema deadline
        if (!next)
            next = itr;
        // pokud tento proces ma deadline...
        else if (itr->task->deadline != Indefinite)
        {
            // vybereme ho jen pokud je deadline drivejsi, nez aktualne vybraneho procesu
            // TODO: preteceni uint32_t
            if (next->task->deadline > itr->task->deadline)
                next = itr;
        }

        itr = itr->next;
    }

    // pokud zadny planovatelny proces nema nastavenou deadline, degradujeme na round-robin planovani
    if (next && next->task->deadline == Indefinite)
        return Schedule_RR();

    return next;
}