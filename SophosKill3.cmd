net stop "Sophos Agent"
net stop "SAVService"
net stop "SAVAdminService"
net stop "Sophos AutoUpdate Service"
net stop "Sophos Client Firewall"
net stop "Sophos Client Firewall Manager"
net stop "Sophos Message Router"
net stop "SntpService"
net stop "sophossps"
net stop "Sophos Web Control Service"
net stop "swi_filter"
net stop "swi_service"

cd C:\ProgramData\Sophos\Sophos Client Firewall\logs
del "scf_data.mdb"
del "scf_data.ldb"
cd C:\WINDOWS\system32

net start "Sophos Agent"
net start "SAVService"
net start "SAVAdminService"
net start "Sophos AutoUpdate Service"
net start "Sophos Client Firewall"
net start "Sophos Client Firewall Manager"
net start "Sophos Message Router"
net start "SntpService"
net start "sophossps"
net start "Sophos Web Control Service"
net start "swi_filter"
net start "swi_service"

cmd /k