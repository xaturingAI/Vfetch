#ifndef V_SYSINFO_H
#define V_SYSINFO_H

typedef struct {
    char* host;
    char* kernel;
    char* uptime;
    char* packages;
    char* shell;
    char* de;
    char* wm;
    char* cpu;
    char* gpu;
    char* memory;
    char* disk;
    char* network;
    char* username;
    char* os_name;
} SystemInfo;

SystemInfo* get_system_info();
void free_system_info(SystemInfo* info);

#endif