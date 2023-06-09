#include <fs/filesystem.h>
#include <drivers/monitor.h>

#include <memory/kernel_heap.h>

#include <stdstring.h>

CFilesystem sFilesystem;

CFilesystem::CFilesystem()
{
    // inicializujeme zakladni strukturu (tedy vlastne obsah root adresare)

    mRoot.parent = nullptr;
    mRoot.next = nullptr;
    mRoot.children = &mRoot_Dev;
    mRoot.isDirectory = true;
    mRoot.driver_idx = NoFilesystemDriver;
    mRoot.name[0] = '\0';

    mRoot_Dev.parent = &mRoot;
    mRoot_Dev.children = nullptr;
    mRoot_Dev.next = &mRoot_Sys;
    mRoot_Dev.isDirectory = true;
    mRoot_Dev.driver_idx = NoFilesystemDriver;
    strncpy(mRoot_Dev.name, "DEV", 4);

    mRoot_Sys.parent = &mRoot;
    mRoot_Sys.children = nullptr;
    mRoot_Sys.next = &mRoot_Mnt;
    mRoot_Sys.isDirectory = true;
    mRoot_Sys.driver_idx = NoFilesystemDriver;
    strncpy(mRoot_Sys.name, "SYS", 4);

    mRoot_Mnt.parent = &mRoot;
    mRoot_Mnt.children = nullptr;
    mRoot_Mnt.next = nullptr;
    mRoot_Mnt.isDirectory = true;
    mRoot_Mnt.driver_idx = NoFilesystemDriver;
    strncpy(mRoot_Mnt.name, "MNT", 4);
}

CFilesystem::TFS_Tree_Node* CFilesystem::TFS_Tree_Node::Find_Child(const char* name)
{
    TFS_Tree_Node* child = children;

    while (child != nullptr)
    {
        if (strncmp(child->name, name, MaxFilenameLength) == 0)
            return child;

        child = child->next;
    }

    return nullptr;
}

void CFilesystem::Initialize()
{
    sMonitor << "Initializing the FS\n";

    char tmpName[MaxFilenameLength];
    const char* mpPtr;

    int i, j;

    for (i = 0; i < gFS_Drivers_Count; i++)
    {
        const TFS_Driver* ptr = &gFS_Drivers[i];

        mpPtr = ptr->mountPoint;

        sMonitor << "mount point = " << mpPtr << "\n";

        TFS_Tree_Node* node = &mRoot, *tmpNode = nullptr;

        while (mpPtr[0] != '\0')
        {
            for (j = 0; j < MaxPathLength && mpPtr[j] != '\0'; j++)
            {
                if (mpPtr[j] == ':' || mpPtr[j] == '/')
                    break;

                tmpName[j] = mpPtr[j];
            }

            tmpName[j] = '\0';

            mpPtr += j;
            if (mpPtr[0] != '\0')
            {
                mpPtr += 1;
            }

            sMonitor << "finding child = " << tmpName << '\n'; 

            tmpNode = node->Find_Child(tmpName);
            // uzel jsme nasli - pouzijeme ho pro dalsi prohledavani
            if (tmpNode) 
            {
                node = tmpNode;
                sMonitor << "child " << tmpName << " was found\n";
            }
            // uzel jsme nenasli - vytvorime ho a pouzijeme ho pro dalsi prohledavani
            else
            {
                tmpNode = sKernelMem.Alloc<TFS_Tree_Node>();
                strncpy(tmpNode->name, tmpName, MaxFilenameLength);
                tmpNode->parent = node;
                tmpNode->children = nullptr;
                tmpNode->driver_idx = NoFilesystemDriver; // zatim - mozna se neco dole zmeni
                tmpNode->isDirectory = true;
                tmpNode->next = node->children;
                node->children = tmpNode;

                node = tmpNode;

                sMonitor << "child was not found\n";
                sMonitor << "creating: " << node->name << "\n";
            }
        }

        // 'node' obsahuje uzel posledniho clanku mountpointu - tedy vlastni mountpoint

        // mountpoint nesmi byt uz zabrany
        if (node->driver_idx != NoFilesystemDriver)
            return;

        node->driver_idx = i; // timto predavame veskere manipulace driveru

        // dame driveru vedet, ze jsme ho zaregistrovali
        ptr->driver->On_Register();
    }

    sMonitor << "Finished FS initialization\n\n";
}

IFile* CFilesystem::Open(const char* path, NFile_Open_Mode mode)
{
    char tmpName[MaxFilenameLength];
    const char* mpPtr;
    sMonitor << "opening file: " << path << "\n";

    int j;

    mpPtr = path;

    TFS_Tree_Node* node = &mRoot, *tmpNode = nullptr;

    while (mpPtr[0] != '\0')
    {
        for (j = 0; j < MaxPathLength && mpPtr[j] != '\0'; j++)
        {
            if (mpPtr[j] == ':' || mpPtr[j] == '/')
                break;

            tmpName[j] = mpPtr[j];
        }

        tmpName[j] = '\0';

        mpPtr += j;
        if (mpPtr[0] != '\0')
        {
            mpPtr += 1;
        }

        tmpNode = node->Find_Child(tmpName);
        if (tmpNode)
            node = tmpNode;

        if (tmpNode->driver_idx != NoFilesystemDriver)
        {
            return gFS_Drivers[tmpNode->driver_idx].driver->Open_File(mpPtr, mode);
        }
        else if (!tmpNode->isDirectory)
            break;
    }

    sMonitor << "failed to open: " << path << "\n";

    // zadny filesystem se tohoto uzlu "neujal" -> soubor neexistuje
    return nullptr;
}
