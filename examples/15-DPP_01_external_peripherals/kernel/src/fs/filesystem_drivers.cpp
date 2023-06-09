#include <fs/filesystem.h>

// includujeme prislusne drivery
#include <fs/drivers/gpio_fs.h>
#include <fs/drivers/monitor_fs.h>
#include <fs/drivers/segmentdisplay_fs.h>
#include <fs/drivers/shiftregister_fs.h>

// pole driveru - tady uvedeme vsechny, ktere jsou v systemu dostupne a ktere je zadouci pro tuto instanci naseho OS pripojit
const CFilesystem::TFS_Driver CFilesystem::gFS_Drivers[] = {
    { "GPIO_FS", "DEV:gpio", &fsGPIO_FS_Driver },
    { "MONITOR_FS", "DEV:monitor", &fsMonitor_FS_Driver },
    { "Shift_Reg_FS", "DEV:sr", &fsShift_Register_FS_Driver },
    { "7Seg_Disp_FS", "DEV:segd", &fsSegment_Display_FS_Driver }
};

// pocet FS driveru - je staticky spocitan z velikosti vyse uvedeneho pole
const uint32_t CFilesystem::gFS_Drivers_Count = sizeof(CFilesystem::gFS_Drivers) / sizeof(CFilesystem::TFS_Driver);
