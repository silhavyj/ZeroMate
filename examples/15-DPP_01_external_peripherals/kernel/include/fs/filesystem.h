#pragma once

#include <hal/intdef.h>
#include <process/swi.h>

constexpr const uint32_t MaxFSDriverNameLength = 16;

constexpr const uint32_t MaxFilenameLength = 16;

constexpr const uint32_t MaxPathLength = 128;

constexpr const uint32_t NoFilesystemDriver = static_cast<uint32_t>(-1);

enum class NFile_Open_Mode
{
    Read_Only,  // jen pro cteni
    Write_Only, // jen pro zapis
    Read_Write, // cteni i zapis
};

/*
 * Format cest bude nasledujici (abychom se trochu lisili od *nix a Windows):
 *
 * ROOTNODE:dir/dir/dir/.../file
 *
 * ROOTNODE je identifikator kategorie souboru, napr. DEV (zarizeni - fyzicka i logicka), SYS (nastaveni, konfigurace),
 * MNT (pripojene fyzicke pameti, napr. SD karta)
 *          - odpovida vlastne polozkam korenoveho adresare VFS (napr. z Linuxu), jen ho natvrdo definujeme pro
 * minimalizaci dynamickych alokaci dir - identifikator adresare, zanoreni libovolne, muze obsahovat pouze znaky
 * 0-9a-zA-Z, pomlcku, tecku a podtrzitko, max. 16 znaku file - identifikator souboru, muze obsahovat jen znaky viz
 * vyse, max. 16 znaku
 *
 * priklad: DEV:gpio/12, DEV:uart0, MNT:sd/config.txt
 */

class IFile
{
public:
    virtual ~IFile() = default;

    // cte ze souboru do bufferu, num je velikost bufferu (maximalni pocet bytu k precteni); vraci skutecne precteny
    // pocet znaku
    virtual uint32_t Read(char* buffer, uint32_t num)
    {
        return 0;
    };
    // zapise z bufferu do souboru, num je velikost bufferu (maximalni pocet bytu k zapsani); vraci skutecne zapsany
    // pocet znaku
    virtual uint32_t Write(const char* buffer, uint32_t num)
    {
        return 0;
    };
    // zavre soubor, vzdy v souladu s danym typem souboru
    virtual bool Close()
    {
        return true;
    };
    // zmeni nastaveni/ziska nastaveni souvisejici s danym souborem; ctlptr je vzdy specificka prepravka pro typ souboru
    virtual bool IOCtl(NIOCtl_Operation dir, void* ctlptr)
    {
        return false;
    };

    // TODO: seek, atd...
};

class IFilesystem_Driver
{
public:
    // vola se v momente, kdy se inicializuje souborovy system
    virtual void On_Register() = 0;
    // otevre soubor
    virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) = 0;
};

class CFilesystem
{
private:
    // uzel filesystemu, ktery neni spravovan zadnym FS driverem
    struct TFS_Tree_Node
    {
        char name[MaxFilenameLength];

        bool isDirectory = false;

        uint32_t driver_idx = NoFilesystemDriver;

        // ukazatel na rodicovsky zaznam, nullptr pokud neni
        TFS_Tree_Node* parent;
        // ukazatel na potomky, nullptr pokud neni
        TFS_Tree_Node* children;

        // ukazatel na dalsi zaznam v adresari, nullptr pokud neni
        TFS_Tree_Node* next;

        TFS_Tree_Node* Find_Child(const char* name);
    };

    // struktura FS driveru
    struct TFS_Driver
    {
        // nazev driveru (pro interni ucely)
        char name[MaxFSDriverNameLength];
        // mountpoint - delame trochu hybrid fstab/mtab, vsechno budeme mountovat predem
        const char* mountPoint;
        // ukazatel na driver
        IFilesystem_Driver* driver;
    };

    // tabulka driveru
    static const TFS_Driver gFS_Drivers[];
    // pocet driveru v tabulce
    static const uint32_t gFS_Drivers_Count;

private:
    TFS_Tree_Node mRoot;

    // ROOTNODE instance
    TFS_Tree_Node mRoot_Dev;
    TFS_Tree_Node mRoot_Sys;
    TFS_Tree_Node mRoot_Mnt;

public:
    CFilesystem();

    // inicializuje souborovy system, pripoji vsechny "svazky" a drivery
    void Initialize();

    // otevre soubor (nebo deleguje otevreni do FS driveru)
    IFile* Open(const char* path, NFile_Open_Mode mode);
};

extern CFilesystem sFilesystem;
