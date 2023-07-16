#pragma once

// maximalni pocet otevrenych souboru
constexpr uint32_t Max_Process_Opened_Files = 16;

// hodnota, ktera znamena, ze proces nema casovy limit na vzbuzeni / deadline
constexpr uint32_t Indefinite = static_cast<uint32_t>(-1);

// hodnota, ktera znamena, ze procesu se nema menit deadline
constexpr uint32_t Deadline_Unchanged = static_cast<uint32_t>(-2);

// vycet stavu procesu
enum class NTask_State
{
    New,      // novy - zatim nenaplanovany, neinicializovany, stav na jiny se zmeni jeste behem vytvareni
    Runnable, // pripraveny k naplanovani (uz mohl v minulosti bezet)
    Running,  // prave naplanovany
    Blocked,  // blokovany - genericky stav pro proces, ktery by sice mohl byt naplanovan, ale ceka na nejaky prostredek
              // pro prakticke ucely se stav "Blokovany" deli jeste na podstavy, aby bylo jasne, na jaky prostredek se
              // ceka (mutex, cteni z disku, jine I/O, ...)
    Interruptable_Sleep, // uspany proces - ceka az vyprsi nejaky casovy interval, popr. pokud ceka na podminkove
                         // promenne, tak ho muze probudit jeste notifikace
    Zombie,              // proces je ukonceny a ceka na to, az si nekdo precte navratovy kod
};

#pragma pack(push, 1)

// kontext provadeni procesu z pohledu CPU - v podstate ulozene registry
struct TCPU_Context
{
    unsigned long lr;
    unsigned long sp;
    unsigned long pc;
    unsigned long ttbr0;
};

#pragma pack(pop)

class IFile;

// struktura procesu (tasku, ...)
struct TTask_Struct
{
    TCPU_Context cpu_context;   // ulozeny kontext procesoru
    unsigned int pid;           // ID procesu, kladne nenulove cislo
    NTask_State state;          // stav procesu
    unsigned int sched_counter; // pocitadlo - jakmile je proces naplanovan, zkopiruje se do nej priorita a kazdy tik
                                // casovace snizuje toto cislo o 1; na 0 se preplanuje na jiny proces
    unsigned int sched_static_priority;            // staticka priorita procesu (dana pri jeho vytvareni)
    IFile* opened_files[Max_Process_Opened_Files]; // otevrene soubory; index je zaroven handle
    int
    exit_code; // navratovy kod procesu; nastaveny pri volani terminate nebo pri vyvolanem data/prefetch abortu a jinych
    uint32_t sleep_timer; // casovac pro uspane procesy - jakmile systemovy citac prekroci tuto hodnotu, proces je
                          // odblokovan maximalni podporovany rozsah cekani je 0x7FFFFFFF, jelikoz muze citac pretect;
                          // diference je vzdy pocitana i s moznosti preteceni
    uint32_t deadline;          // deadline dokonceni tasku
    uint32_t notified_deadline; // deadline nastavena po nasledujicim probuzeni procesu
};
