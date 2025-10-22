import { useParams } from "react-router-dom";
import { useState } from "react";
import "./CategoryPage.css";

const CategoryPage = () => {
  const { category } = useParams();
  const [searchQuery, setSearchQuery] = useState("");

  // All scripts for all categories
  const allScripts = {
    memory: [
      {
        name: "Cleanop",
        description: "Cleanop command cleans unnecessary memory and frees up space.",
        solution: "Cleans unnecessary memory and frees up space.",
        author: "Ameya Unchagaonkar",
        downloadLink: "/scripts/cleanop.sh",
      },
      {
        name: "MemoryCheck",
        description: "Checks memory usage and provides a detailed report.",
        solution: "Checks memory usage and provides a detailed report.",
        downloadLink: "/scripts/MemoryCheck.sh",
      },
      {
        name: "SwapCleaner",
        description: "Clears swap memory to free up system resources.",
        solution: "Clears swap memory to free up system resources.",
        author: "Kartikey Lodhe (TY)",
        downloadLink: "/scripts/SwapCleaner.sh",
      },
      {
        name: "CacheClear",
        description: "Clears system cache to free up memory.",
        solution: "Clears system cache to free up memory.",
        author: "Vishant Sutar (SY)",
        downloadLink: "/scripts/CacheClear.sh",
      },
      {
        name: "OOMKillerAnalyzer",
        description: "Analyzes Out-Of-Memory (OOM) killer logs.",
        solution: "Analyzes Out-Of-Memory (OOM) killer logs.",
        downloadLink: "/scripts/OOMKillerAnalyzer.sh",
      },
      {
        name: "ProcessKiller",
        description: "Identifies and kills memory-hogging processes.",
        solution: "Identifies and kills memory-hogging processes.",
        downloadLink: "/scripts/ProcessKiller.sh",
      },
      {
        name: "MemoryOptimizer",
        description: "Optimizes memory usage by adjusting system parameters.",
        solution: "Optimizes memory usage by adjusting system parameters.",
        downloadLink: "/scripts/MemoryOptimizer.sh",
      },
      {
        name: "LogCleaner",
        description: "Cleans up old log files to free up disk space.",
        author: "Ameya Unchagaonkar",
        solution: "Cleans up old log files to free up disk space.",
        downloadLink: "/scripts/LogCleaner.sh",
      },
      {
        name: "TmpCleaner",
        description: "Cleans up temporary files to free up memory.",
        solution: "Cleans up temporary files to free up memory.",
        downloadLink: "/scripts/TmpCleaner.sh",
      },
      {
        name: "MemoryLeakDetector",
        description: "Detects memory leaks in running processes.",
        solution: "Implements memory leak detection, analysis, and automatic cleanup procedures. Uses advanced memory profiling tools and automatic garbage collection optimization.",
        downloadLink: "/scripts/MemoryLeakDetector.sh",
      },
      {
        name: "MemoryHealthCheck",
        description: "Performs a comprehensive health check of system memory.",
        solution: "Implements system memory diagnostics, performance analysis, and optimization recommendations. Ensures optimal memory usage and system stability.",
        downloadLink: "/scripts/MemoryHealthCheck.sh",
      },
      {
        name: "Memory Leak Detection",
        description: "Solves common memory leak issues in applications.",
        solution: "Implements memory leak detection, analysis, and automatic cleanup procedures. Uses advanced memory profiling tools and automatic garbage collection optimization.",
        downloadLink: "/scripts/Memory_Leak_Detection.sh",
      },
      {
        name: "Swap Space Optimization",
        description: "Fixes swap space configuration and performance issues.",
        solution: "Optimizes swap space allocation, implements proper swapiness values, and ensures efficient memory management. Automatically adjusts swap settings based on system load.",
        downloadLink: "/scripts/Swap_Space_Optimization.sh",
      },
      {
        name: "OOM Killer Configuration",
        description: "Resolves Out of Memory (OOM) killer issues and system crashes.",
        solution: "Configures proper OOM killer parameters, implements memory limits, and ensures system stability. Prevents system crashes by intelligently managing memory resources.",
        downloadLink: "/scripts/OOM_Killer_Configuration.sh",
      },
      {
        name: "Memory Fragmentation",
        description: "Solves memory fragmentation issues affecting system performance.",
        solution: "Implements memory defragmentation, optimizes memory allocation, and ensures proper cleanup. Uses advanced algorithms to prevent memory fragmentation.",
        downloadLink: "/scripts/Memory_Fragmentation.sh",
      },
      {
        name: "Cache Management",
        description: "Fixes cache management and performance issues.",
        solution: "Optimizes cache parameters, implements proper cache policies, and ensures efficient memory usage. Automatically adjusts cache settings for optimal performance.",
        downloadLink: "/scripts/Cache_Management.sh",
      }
    ],
    labs: [
      {
        name: "All Databse",
        description: "Run the databse of your choice",
        solution: "Runs the database of your choice.",
        downloadLink: "/scripts/LabSetup.sh",
      },
      {
        name: "Lab Cleanup",
        description: "Cleans up the lab environment.",
        solution: "Cleans up the lab environment.",
        author:"Tanmay Shingde (TY)",
        downloadLink: "/scripts/LabCleanup.sh",
      },
      {
        name: "Lab Backup",
        description: "Creates a backup of the lab environment.",
        solution: "Creates a backup of the lab environment.",
        downloadLink: "/scripts/LabBackup.sh",
      },
      {
        name: "Lab Restore",
        description: "Restores the lab environment from a backup.",
        solution: "Restores the lab environment from a backup.",
        downloadLink: "/scripts/Lab_Restore.sh",
      },
      {
        name: "Database Backup",
        description: "Creates a backup of your SQL database.",
        solution: "Creates a backup of your SQL database.",
        downloadLink: "/scripts/BackupSQL.sh",
      },
      {
        name: "Java Runner",
        description: "Compiles and runs Java programs.",
        solution: "Compiles and runs Java programs.",
        downloadLink: "/scripts/Javarun.sh",
      },
      {
        name: "OpenMP Runner",
        description: "Compiles and runs OpenMP programs.",
        solution: "Compiles and runs OpenMP programs.",
        downloadLink: "/scripts/OpenmpRun.sh",
      },
      {
        name: "Emulator Runner",
        description: "Runs an emulator for testing purposes.",
        solution: "Runs an emulator for testing purposes.",
        downloadLink: "/scripts/Emulatorrun.sh",
      },
      {
        name: "Ping Server",
        description: "Pings a server to check connectivity.",
        solution: "Pings a server to check connectivity.",
        downloadLink: "/scripts/Pingserver.sh",
      },
      {
        name: "Resource Usage Monitor",
        description: "Monitors system resource usage.",
        solution: "Monitors system resource usage.",
        downloadLink: "/scripts/ResUsage.sh",
      },
      {
        name: "OpenCV Installer",
        description: "Installs OpenCV for image processing.",
        solution: "Installs OpenCV for image processing.",
        downloadLink: "/scripts/OpencvInstall.sh",
      },
      {
        name: "Python Runner",
        description: "Runs Python scripts.",
        solution: "Runs Python scripts.",
        downloadLink: "/scripts/RunPython.sh",
      },
      {
        name: "C++ Runner",
        description: "Compiles and runs C++ programs.",
        solution: "Compiles and runs C++ programs.",
        downloadLink: "/scripts/RunCpp.sh",
      },
      {
        name: "MPI Runner",
        description: "Compiles and runs MPI programs.",
        solution: "Compiles and runs MPI programs.",
        downloadLink: "/scripts/RunMPI.sh",
      },
      {
        name: "Image Resizer",
        description: "Resizes images using Python (Pillow).",
        solution: "Resizes images using Python (Pillow).",
        downloadLink: "/scripts/Resizeimg.sh",
      },
      {
        name: "Lab Environment Setup",
        description: "Resolves common lab environment setup and configuration issues.",
        solution: "Automates lab environment setup with proper networking, security, and resource allocation. Ensures consistent environment across all lab machines.",
        downloadLink: "/scripts/Lab_Environment_Setup.sh",
      },
      {
        name: "Virtual Machine Management",
        description: "Fixes virtual machine performance and management issues.",
        solution: "Optimizes VM configurations, implements proper resource allocation, and ensures efficient management. Automatically scales resources based on workload.",
        downloadLink: "/scripts/Virtual_Machine_Management.sh",
      },
      {
        name: "Network Isolation",
        description: "Solves network isolation and security challenges in lab environments.",
        solution: "Implements proper network segmentation, firewall rules, and access controls. Ensures secure communication between lab components.",
        downloadLink: "/scripts/Network_Isolation.sh",
      },
      {
        name: "Resource Allocation",
        description: "Resolves resource allocation and management issues in lab environments.",
        solution: "Implements proper resource quotas, monitoring, and allocation strategies. Ensures fair distribution of resources among lab users.",
        downloadLink: "/scripts/Resource_Allocation.sh",
      },
      {
        name: "Lab Backup and Recovery",
        description: "Fixes lab environment backup and recovery challenges.",
        solution: "Implements automated backup procedures, recovery mechanisms, and data protection strategies. Ensures quick recovery from system failures.",
        downloadLink: "/scripts/Lab_Backup_Recovery.sh",
      },
      {
        name: "Lab Environment Monitoring",
        description: "Monitors lab environment health and performance.",
        solution: "Implements comprehensive monitoring, alerting, and reporting. Ensures lab environment stability and performance.",
        downloadLink: "/scripts/Lab_Environment_Monitoring.sh",
      },
      {
        name: "Lab Security Hardening",
        description: "Enhances lab environment security.",
        solution: "Implements security hardening, access control, and vulnerability management. Ensures lab environment security and compliance.",
        downloadLink: "/scripts/Lab_Security_Hardening.sh",
      },
      {
        name: "Lab Software Deployment",
        description: "Manages lab software deployment and updates.",
        solution: "Implements automated software deployment, version control, and update management. Ensures consistent software environment.",
        downloadLink: "/scripts/Lab_Software_Deployment.sh",
      },
      {
        name: "Lab User Management",
        description: "Manages lab user accounts and permissions.",
        solution: "Implements user account management, access control, and permission management. Ensures proper user access and security.",
        downloadLink: "/scripts/Lab_User_Management.sh",
      },
      {
        name: "Lab Network Configuration",
        description: "Configures lab network settings and security.",
        solution: "Implements network configuration, security policies, and access control. Ensures proper network functionality and security.",
        downloadLink: "/scripts/Lab_Network_Configuration.sh",
      }
    ],
    drivers: [
        {
          name: "Check NVIDIA Driver Installation",
          description: "Checks if NVIDIA drivers are installed correctly.",
        solution: "Implements comprehensive driver verification, version checking, and installation status validation. Ensures proper driver functionality and compatibility.",
          downloadLink: "/scripts/Check_NVIDIA_Driver_Installation.sh",
        },
        {
          name: "Install AMD Graphics Driver",
          description: "Installs AMD graphics drivers.",
        solution: "Implements automated AMD driver installation, version management, and configuration. Ensures proper graphics performance and compatibility.",
          downloadLink: "/scripts/Install_AMD_Graphics_Driver.sh",
        },
        {
          name: "Install Realtek WiFi Drivers",
          description: "Installs Realtek WiFi drivers.",
        solution: "Implements Realtek WiFi driver installation, firmware updates, and network configuration. Ensures stable wireless connectivity.",
          downloadLink: "/scripts/Install_Realtek_WiFi_Drivers.sh",
        },
        {
          name: "Install Broadcom WiFi Driver",
          description: "Installs Broadcom WiFi drivers.",
        solution: "Implements Broadcom WiFi driver installation, firmware management, and network optimization. Ensures reliable wireless performance.",
          downloadLink: "/scripts/Install_Broadcom_WiFi_Driver.sh",
        },
        {
          name: "Install USB 3.0 Drivers",
          description: "Installs USB 3.0 drivers.",
        solution: "Implements USB 3.0 driver installation, device recognition, and performance optimization. Ensures proper USB device functionality.",
          downloadLink: "/scripts/Install_USB_3_0_Drivers.sh",
        },
        {
          name: "Install ALSA Audio Drivers",
          description: "Installs ALSA audio drivers.",
        solution: "Implements ALSA audio driver installation, sound configuration, and device management. Ensures proper audio functionality.",
          downloadLink: "/scripts/Install_ALSA_Audio_Drivers.sh",
        },
        {
          name: "Check Audio Driver Installation Status",
          description: "Checks the status of audio driver installation.",
        solution: "Implements audio driver verification, device detection, and configuration validation. Ensures proper audio system operation.",
          downloadLink: "/scripts/Check_Audio_Driver_Installation_Status.sh",
        },
        {
          name: "Reinstall Ethernet Drivers",
          description: "Reinstalls Ethernet drivers.",
        solution: "Implements Ethernet driver reinstallation, network configuration, and connection optimization. Ensures stable network connectivity.",
          downloadLink: "/scripts/Reinstall_Ethernet_Drivers.sh",
        },
        {
          name: "Install Printer Drivers (CUPS)",
          description: "Installs printer drivers using CUPS.",
        solution: "Implements CUPS printer driver installation, device configuration, and print queue management. Ensures proper printer functionality.",
          downloadLink: "/scripts/Install_Printer_Drivers_CUPS.sh",
        },
        {
          name: "Check and Fix NVIDIA Driver Issues",
          description: "Checks and fixes common NVIDIA driver issues.",
        solution: "Implements NVIDIA driver diagnostics, issue detection, and automated fixes. Ensures optimal graphics performance.",
          downloadLink: "/scripts/Check_and_Fix_NVIDIA_Driver_Issues.sh",
        },
        {
          name: "Install VirtualBox Drivers",
          description: "Installs VirtualBox drivers.",
        solution: "Implements VirtualBox driver installation, guest additions setup, and virtualization optimization. Ensures proper virtual machine operation.",
          downloadLink: "/scripts/Install_VirtualBox_Drivers.sh",
        },
        {
          name: "Install NVIDIA CUDA Toolkit",
          description: "Installs the NVIDIA CUDA toolkit.",
        solution: "Implements CUDA toolkit installation, GPU acceleration setup, and development environment configuration. Ensures proper GPU computing capabilities.",
          downloadLink: "/scripts/Install_NVIDIA_CUDA_Toolkit.sh",
        },
        {
          name: "Install Intel Wireless Drivers",
          description: "Installs Intel wireless drivers.",
        solution: "Implements Intel wireless driver installation, firmware updates, and network optimization. Ensures reliable wireless connectivity.",
          downloadLink: "/scripts/Install_Intel_Wireless_Drivers.sh",
        },
        {
          name: "Install Bluetooth Drivers",
          description: "Installs Bluetooth drivers.",
        solution: "Implements Bluetooth driver installation, device pairing, and connection management. Ensures proper Bluetooth functionality.",
          downloadLink: "/scripts/Install_Bluetooth_Drivers.sh",
        },
        {
          name: "Check Graphics Driver Installation",
          description: "Checks if graphics drivers are installed correctly.",
        solution: "Implements graphics driver verification, performance testing, and configuration validation. Ensures proper display functionality.",
          downloadLink: "/scripts/Check_Graphics_Driver_Installation.sh",
        },
        {
          name: "Install NVIDIA Optimus Driver",
          description: "Installs NVIDIA Optimus drivers.",
        solution: "Implements NVIDIA Optimus driver installation, GPU switching, and power management. Ensures optimal graphics performance and battery life.",
          downloadLink: "/scripts/Install_NVIDIA_Optimus_Driver.sh",
        },
        {
          name: "Install NVIDIA Hybrid Graphics Driver",
          description: "Installs NVIDIA hybrid graphics drivers.",
        solution: "Implements hybrid graphics driver installation, GPU switching, and power optimization. Ensures efficient graphics performance.",
          downloadLink: "/scripts/Install_NVIDIA_Hybrid_Graphics_Driver.sh",
        },
        {
          name: "Install VirtualBox Guest Additions",
          description: "Installs VirtualBox Guest Additions.",
        solution: "Implements Guest Additions installation, virtual machine optimization, and host-guest integration. Enhances virtual machine performance.",
          downloadLink: "/scripts/Install_VirtualBox_Guest_Additions.sh",
        },
        {
          name: "Install Docker",
          description: "Installs Docker on the system.",
        solution: "Implements Docker installation, container runtime setup, and system configuration. Ensures proper containerization capabilities.",
          downloadLink: "/scripts/Install_Docker.sh",
        },
        {
          name: "Update Kernel to Resolve Driver Issues",
          description: "Updates the kernel to resolve driver-related issues.",
        solution: "Implements kernel update, driver compatibility checks, and system optimization. Ensures proper driver functionality and system stability.",
          downloadLink: "/scripts/Update_Kernel_to_Resolve_Driver_Issues.sh",
        },
        {
          name: "Install OpenCL Drivers for AMD",
          description: "Installs OpenCL drivers for AMD GPUs.",
        solution: "Implements OpenCL driver installation, GPU acceleration setup, and compute environment configuration. Ensures proper GPU computing capabilities.",
          downloadLink: "/scripts/Install_OpenCL_Drivers_for_AMD.sh",
        },
        {
          name: "Check and Fix USB Driver Issues",
          description: "Checks and fixes common USB driver issues.",
        solution: "Implements USB driver diagnostics, issue detection, and automated fixes. Ensures proper USB device functionality.",
          downloadLink: "/scripts/Check_and_Fix_USB_Driver_Issues.sh",
        },
        {
          name: "Install Android USB Drivers",
          description: "Installs USB drivers for Android devices.",
        solution: "Implements Android USB driver installation, device recognition, and debugging setup. Ensures proper Android device connectivity.",
          downloadLink: "/scripts/Install_Android_USB_Drivers.sh",
        },
        {
          name: "Install Raspberry Pi GPU Driver",
          description: "Installs GPU drivers for Raspberry Pi.",
        solution: "Implements Raspberry Pi GPU driver installation, display configuration, and performance optimization. Ensures proper graphics functionality.",
          downloadLink: "/scripts/Install_Raspberry_Pi_GPU_Driver.sh",
        },
      {
        name: "Fix NVIDIA Driver Black Screen",
        description: "Solves the common black screen issue after NVIDIA driver updates by properly configuring Xorg and kernel parameters.",
        solution: "Automatically detects and fixes Xorg configuration, updates kernel parameters, and ensures proper driver loading sequence.",
        downloadLink: "/scripts/NVIDIA_Black_Screen_Fix.sh",
      },
      {
        name: "AMD GPU Fan Control",
        description: "Fixes AMD GPU fan control issues and overheating problems by implementing proper fan curve management.",
        solution: "Configures AMD GPU fan control through sysfs, sets up custom fan curves, and ensures proper thermal management.",
        downloadLink: "/scripts/AMD_GPU_Fan_Control.sh",
      },
      {
        name: "WiFi Driver Power Management",
        description: "Resolves WiFi disconnection and power management issues with common wireless drivers.",
        solution: "Disables aggressive power saving, optimizes WiFi parameters, and ensures stable connection.",
        downloadLink: "/scripts/WiFi_Power_Management.sh",
      },
      {
        name: "USB Device Recognition",
        description: "Fixes USB device recognition issues and enumeration problems.",
        solution: "Resets USB controllers, updates udev rules, and ensures proper device enumeration.",
        downloadLink: "/scripts/USB_Device_Recognition.sh",
      },
      {
        name: "Bluetooth Driver Troubleshooting",
        description: "Solves Bluetooth connectivity and pairing issues with various adapters.",
        solution: "Resets Bluetooth stack, updates firmware, and configures proper Bluetooth protocols.",
        downloadLink: "/scripts/Bluetooth_Troubleshooting.sh",
      },
    ],
    tools: [
      {
        name: "System Performance Monitor",
        description: "Comprehensive system performance monitoring and analysis.",
        solution: "Implements real-time system monitoring, performance metrics collection, and automated analysis. Provides detailed performance reports and optimization suggestions.",
        downloadLink: "/scripts/System_Performance_Monitor.sh",
      },
      {
        name: "Network Troubleshooting",
        description: "Advanced network troubleshooting and diagnostics.",
        solution: "Implements network diagnostics, packet analysis, and automated troubleshooting. Identifies and resolves network issues quickly.",
        downloadLink: "/scripts/Network_Troubleshooting.sh",
      },
      {
        name: "Security Scanner",
        description: "Comprehensive system security scanning and vulnerability assessment.",
        solution: "Implements security scanning, vulnerability detection, and automated patching. Ensures system security and compliance.",
        downloadLink: "/scripts/Security_Scanner.sh",
      },
      {
        name: "Backup Automation",
        description: "Automated system backup and recovery solution.",
        solution: "Implements automated backup scheduling, data verification, and recovery procedures. Ensures data safety and quick recovery.",
        downloadLink: "/scripts/Backup_Automation.sh",
      },
      {
        name: "System Cleanup",
        description: "Automated system cleanup and optimization.",
        solution: "Implements system cleanup, temporary file removal, and disk optimization. Improves system performance and frees up disk space.",
        downloadLink: "/scripts/System_Cleanup.sh",
      },
      {
        name: "Log Analyzer",
        description: "Advanced system log analysis and monitoring.",
        solution: "Implements log collection, analysis, and alerting. Identifies system issues and provides actionable insights.",
        downloadLink: "/scripts/Log_Analyzer.sh",
      },
      {
        name: "Process Manager",
        description: "Advanced process management and monitoring.",
        solution: "Implements process monitoring, resource tracking, and optimization. Ensures efficient system resource usage.",
        downloadLink: "/scripts/Process_Manager.sh",
      },
      {
        name: "System Health Check",
        description: "Comprehensive system health check and diagnostics.",
        solution: "Implements system diagnostics, performance analysis, and health reporting. Ensures system stability and performance.",
        downloadLink: "/scripts/System_Health_Check.sh",
      },
      {
        name: "Resource Monitor",
        description: "Advanced system resource monitoring and management.",
        solution: "Implements resource monitoring, allocation tracking, and optimization. Ensures efficient resource usage.",
        downloadLink: "/scripts/Resource_Monitor.sh",
      },
      {
        name: "System Update Manager",
        description: "Automated system update and patch management.",
        solution: "Implements update scheduling, patch management, and version control. Ensures system security and stability.",
        downloadLink: "/scripts/System_Update_Manager.sh",
      }
    ],
    softwares: [
      {
        name: "Package Management",
        description: "Advanced package management and dependency resolution.",
        solution: "Implements intelligent package management, dependency resolution, and conflict handling. Ensures smooth software installation and updates.",
        downloadLink: "/scripts/Package_Management.sh",
      },
      {
        name: "Software Installation",
        description: "Automated software installation and configuration.",
        solution: "Implements automated software installation, configuration, and verification. Ensures consistent software setup across systems.",
        downloadLink: "/scripts/Software_Installation.sh",
      },
      {
        name: "Version Control",
        description: "Advanced version control and software management.",
        solution: "Implements version control, software tracking, and update management. Ensures proper software versioning and updates.",
        downloadLink: "/scripts/Version_Control.sh",
      },
      {
        name: "Configuration Management",
        description: "Automated software configuration management.",
        solution: "Implements configuration management, settings synchronization, and backup. Ensures consistent software configuration.",
        downloadLink: "/scripts/Configuration_Management.sh",
      },
      {
        name: "Software Updates",
        description: "Automated software update and patch management.",
        solution: "Implements automated updates, patch management, and version control. Ensures systems are always up-to-date.",
        downloadLink: "/scripts/Software_Updates.sh",
      },
      {
        name: "Dependency Management",
        description: "Advanced software dependency management.",
        solution: "Implements dependency tracking, resolution, and conflict handling. Ensures proper software dependencies.",
        downloadLink: "/scripts/Dependency_Management.sh",
      },
      {
        name: "Software Verification",
        description: "Software integrity verification and validation.",
        solution: "Implements software verification, integrity checking, and validation. Ensures software authenticity and security.",
        downloadLink: "/scripts/Software_Verification.sh",
      },
      {
        name: "Software Removal",
        description: "Clean software removal and cleanup.",
        solution: "Implements software removal, dependency cleanup, and system optimization. Ensures clean software uninstallation.",
        downloadLink: "/scripts/Software_Removal.sh",
      },
      {
        name: "Software Backup",
        description: "Software configuration backup and restore.",
        solution: "Implements software backup, configuration preservation, and restore procedures. Ensures software data safety.",
        downloadLink: "/scripts/Software_Backup.sh",
      },
      {
        name: "Software Monitoring",
        description: "Software performance monitoring and analysis.",
        solution: "Implements software monitoring, performance tracking, and optimization. Ensures optimal software performance.",
        downloadLink: "/scripts/Software_Monitoring.sh",
      }
    ],
    docker: [
      {
        name: "Container Optimization",
        description: "Advanced Docker container optimization and management.",
        solution: "Implements container optimization, resource management, and performance tuning. Ensures efficient container operation.",
        downloadLink: "/scripts/Container_Optimization.sh",
      },
      {
        name: "Image Management",
        description: "Docker image management and optimization.",
        solution: "Implements image management, optimization, and cleanup. Reduces storage usage and improves performance.",
        downloadLink: "/scripts/Image_Management.sh",
      },
      {
        name: "Network Configuration",
        description: "Docker network configuration and optimization.",
        solution: "Implements network configuration, security, and performance optimization. Ensures proper container networking.",
        downloadLink: "/scripts/Network_Configuration.sh",
      },
      {
        name: "Volume Management",
        description: "Docker volume management and optimization.",
        solution: "Implements volume management, backup, and optimization. Ensures proper data persistence.",
        downloadLink: "/scripts/Volume_Management.sh",
      },
      {
        name: "Security Hardening",
        description: "Docker security hardening and compliance.",
        solution: "Implements security hardening, compliance checks, and vulnerability scanning. Ensures container security.",
        downloadLink: "/scripts/Security_Hardening.sh",
      },
      {
        name: "Container Monitoring",
        description: "Docker container monitoring and management.",
        solution: "Implements container monitoring, performance tracking, and optimization. Ensures container health and performance.",
        downloadLink: "/scripts/Container_Monitoring.sh",
      },
      {
        name: "Container Backup",
        description: "Docker container backup and recovery.",
        solution: "Implements container backup, data preservation, and recovery procedures. Ensures container data safety.",
        downloadLink: "/scripts/Container_Backup.sh",
      },
      {
        name: "Container Scaling",
        description: "Docker container scaling and load balancing.",
        solution: "Implements container scaling, load balancing, and resource optimization. Ensures proper container distribution.",
        downloadLink: "/scripts/Container_Scaling.sh",
      },
      {
        name: "Container Logging",
        description: "Docker container logging and analysis.",
        solution: "Implements container logging, analysis, and alerting. Provides container insights and troubleshooting.",
        downloadLink: "/scripts/Container_Logging.sh",
      },
      {
        name: "Container Security",
        description: "Docker container security and compliance.",
        solution: "Implements container security, access control, and vulnerability management. Ensures container protection.",
        downloadLink: "/scripts/Container_Security.sh",
      }
    ],
    networking: [
      {
        name: "Show IP Configuration",
        description: "Displays detailed IP configuration and network settings.",
        solution: "Implements IP configuration display, network interface details, and routing information. Provides comprehensive network insights.",
        author: "Yash Patil",
        downloadLink: "/scripts/Show_IP.sh",
      },
      {
        name: "Network Information",
        description: "Displays detailed network information and statistics.",
        solution: "Implements network diagnostics, performance metrics, and configuration details. Provides comprehensive network insights.",
        author: "Yash Patil",
        downloadLink: "/scripts/Network_Info.sh",
      },
      {
        name: "Network Configuration",
        description: "Advanced network configuration and optimization.",
        solution: "Implements network configuration, optimization, and security. Ensures proper network operation.",
        downloadLink: "/scripts/Network_Configuration.sh",
      },
      {
        name: "Firewall Management",
        description: "Firewall configuration and management.",
        solution: "Implements firewall rules, security policies, and monitoring. Ensures network security.",
        downloadLink: "/scripts/Firewall_Management.sh",
      },
      {
        name: "DNS Configuration",
        description: "DNS server configuration and optimization.",
        solution: "Implements DNS configuration, caching, and security. Ensures proper name resolution.",
        downloadLink: "/scripts/DNS_Configuration.sh",
      },
      {
        name: "VPN Setup",
        description: "VPN server setup and configuration.",
        solution: "Implements VPN setup, security, and client management. Ensures secure remote access.",
        downloadLink: "/scripts/VPN_Setup.sh",
      },
      {
        name: "Load Balancing",
        description: "Load balancer configuration and optimization.",
        solution: "Implements load balancing, failover, and monitoring. Ensures high availability.",
        downloadLink: "/scripts/Load_Balancing.sh",
      },
      {
        name: "Network Monitoring",
        description: "Advanced network monitoring and analysis.",
        solution: "Implements network monitoring, performance tracking, and optimization. Ensures network health and performance.",
        downloadLink: "/scripts/Network_Monitoring.sh",
      },
      {
        name: "Network Security",
        description: "Network security configuration and management.",
        solution: "Implements network security, access control, and vulnerability management. Ensures network protection.",
        downloadLink: "/scripts/Network_Security.sh",
      },
      {
        name: "Network Troubleshooting",
        description: "Network troubleshooting and diagnostics.",
        solution: "Implements network diagnostics, issue detection, and automated fixes. Ensures network reliability.",
        downloadLink: "/scripts/Network_Troubleshooting.sh",
      },
      {
        name: "Network Backup",
        description: "Network configuration backup and recovery.",
        solution: "Implements network backup, configuration preservation, and restore procedures. Ensures network data safety.",
        downloadLink: "/scripts/Network_Backup.sh",
      },
      {
        name: "Network Optimization",
        description: "Network performance optimization.",
        solution: "Implements network optimization, performance tuning, and resource management. Ensures optimal network performance.",
        downloadLink: "/scripts/Network_Optimization.sh",
      }
    ],
    'cloud computing': [
      {
        name: "Cloud Resource Management",
        description: "Cloud resource management and optimization.",
        solution: "Implements resource management, cost optimization, and monitoring. Ensures efficient cloud usage.",
        downloadLink: "/scripts/Cloud_Resource_Management.sh",
      },
      {
        name: "Auto-scaling Configuration",
        description: "Cloud auto-scaling setup and management.",
        solution: "Implements auto-scaling, load balancing, and monitoring. Ensures proper resource scaling.",
        downloadLink: "/scripts/Auto_scaling_Configuration.sh",
      },
      {
        name: "Cloud Security",
        description: "Cloud security configuration and management.",
        solution: "Implements security policies, access control, and monitoring. Ensures cloud security.",
        downloadLink: "/scripts/Cloud_Security.sh",
      },
      {
        name: "Backup and Recovery",
        description: "Cloud backup and recovery management.",
        solution: "Implements backup scheduling, data protection, and recovery procedures. Ensures data safety.",
        downloadLink: "/scripts/Backup_Recovery.sh",
      },
      {
        name: "Cost Optimization",
        description: "Cloud cost optimization and management.",
        solution: "Implements cost monitoring, optimization, and reporting. Reduces cloud expenses.",
        downloadLink: "/scripts/Cost_Optimization.sh",
      },
      {
        name: "Cloud Monitoring",
        description: "Cloud resource monitoring and analysis.",
        solution: "Implements cloud monitoring, performance tracking, and optimization. Ensures cloud health and performance.",
        downloadLink: "/scripts/Cloud_Monitoring.sh",
      },
      {
        name: "Cloud Migration",
        description: "Cloud migration and deployment management.",
        solution: "Implements cloud migration, deployment automation, and configuration management. Ensures smooth cloud transitions.",
        downloadLink: "/scripts/Cloud_Migration.sh",
      },
      {
        name: "Cloud Compliance",
        description: "Cloud compliance and governance management.",
        solution: "Implements compliance checks, governance policies, and security standards. Ensures cloud compliance.",
        downloadLink: "/scripts/Cloud_Compliance.sh",
      },
      {
        name: "Cloud Backup",
        description: "Cloud data backup and disaster recovery.",
        solution: "Implements cloud backup, data protection, and recovery procedures. Ensures cloud data safety.",
        downloadLink: "/scripts/Cloud_Backup.sh",
      },
      {
        name: "Cloud Optimization",
        description: "Cloud performance optimization and management.",
        solution: "Implements cloud optimization, performance tuning, and resource management. Ensures optimal cloud performance.",
        downloadLink: "/scripts/Cloud_Optimization.sh",
      }
    ],
    cybersecurity: [
      {
        name: "Password generator",
        description: "Generates strong, random passwords.",
        solution: "Generates strong, random passwords using a combination of letters, numbers, and special characters. Ensures password security.",
        author: "Yash Patil",
        downloadLink: "/scripts/Password_Generator.sh",
      },
      {
        name: "Check Open Ports",
        description: "Checks open ports.",
        solution: "Checks open ports.",
        downloadLink: "/scripts/Check_Open_Ports.sh",
      },
      {
        name: "Check System Logs",
        description: "Checks system logs for suspicious activity.",
        solution: "Checks system logs for suspicious activity.",
        downloadLink: "/scripts/Check_System_Logs.sh",
      },
      {
        name: "Update Security Patches",
        description: "Updates system and applies security patches.",
        solution: "Updates system and applies security patches.",
        downloadLink: "/scripts/Update_Security_Patches.sh",
      },
      {
        name: "Check Firewall Status",
        description: "Checks the status of the firewall.",
        solution: "Checks the status of the firewall.",
        downloadLink: "/scripts/Check_Firewall_Status.sh",
      },
      {
        name: "Enable Firewall",
        description: "Enables the firewall.",
        solution: "Enables the firewall.",
        downloadLink: "/scripts/Enable_Firewall.sh",
      },
      {
        name: "Disable Firewall",
        description: "Disables the firewall.",
        solution: "Disables the firewall.",
        downloadLink: "/scripts/Disable_Firewall.sh",
      },
      {
        name: "List Active User Sessions",
        description: "Lists all active user sessions.",
        solution: "Lists all active user sessions.",
        downloadLink: "/scripts/List_Active_User_Sessions.sh",
      },
      {
        name: "Change User Password",
        description: "Changes the password of the current user.",
        solution: "Changes the password of the current user.",
        downloadLink: "/scripts/Change_User_Password.sh",
      },
      {
        name: "Check Suspicious Processes",
        description: "Checks for suspicious processes running on the system.",
        solution: "Checks for suspicious processes running on the system.",
        downloadLink: "/scripts/Check_Suspicious_Processes.sh",
      },
      {
        name: "Check File Permissions",
        description: "Checks file permissions in a specified directory.",
        solution: "Checks file permissions in a specified directory.",
        downloadLink: "/scripts/Check_File_Permissions.sh",
      },
      {
        name: "Scan System for Malware",
        description: "Scans the system for malware.",
        solution: "Scans the system for malware.",
        downloadLink: "/scripts/Scan_System_for_Malware.sh",
      },
      {
        name: "Check for Rootkits",
        description: "Checks the system for rootkits.",
        solution: "Checks the system for rootkits.",
        downloadLink: "/scripts/Check_for_Rootkits.sh",
      },
      {
        name: "Monitor System for Intrusions",
        description: "Monitors the system for intrusions.",
        solution: "Monitors the system for intrusions.",
        downloadLink: "/scripts/Monitor_System_for_Intrusions.sh",
      },
      {
        name: "Enable SELinux",
        description: "Enables SELinux on the system.",
        solution: "Enables SELinux on the system.",
        downloadLink: "/scripts/Enable_SELinux.sh",
      },
      {
        name: "Disable SELinux",
        description: "Disables SELinux on the system.",
        solution: "Disables SELinux on the system.",
        downloadLink: "/scripts/Disable_SELinux.sh",
      },
      {
        name: "Install and Update Antivirus",
        description: "Installs and updates antivirus software.",
        solution: "Installs and updates antivirus software.",
        downloadLink: "/scripts/Install_Update_Antivirus.sh",
      },
      {
        name: "Check System Integrity",
        description: "Checks the integrity of the system.",
        solution: "Checks the integrity of the system.",
        downloadLink: "/scripts/Check_System_Integrity.sh",
      },
      {
        name: "Monitor Network Traffic",
        description: "Monitors network traffic.",
        solution: "Monitors network traffic.",
        downloadLink: "/scripts/Monitor_Network_Traffic.sh",
      },
      {
        name: "Backup Critical Files",
        description: "Backs up critical files.",
        solution: "Backs up critical files.",
        downloadLink: "/scripts/Backup_Critical_Files.sh",
      },
      {
        name: "Setup Two-Factor Authentication (2FA)",
        description: "Sets up two-factor authentication for the system.",
        solution: "Sets up two-factor authentication for the system.",
        downloadLink: "/scripts/Setup_2FA.sh",
      },
      {
        name: "Security Hardening",
        description: "System security hardening and compliance.",
        solution: "Implements security hardening, compliance checks, and vulnerability scanning. Ensures system security.",
        downloadLink: "/scripts/Security_Hardening.sh",
      },
      {
        name: "Intrusion Detection",
        description: "Intrusion detection and prevention system.",
        solution: "Implements intrusion detection, monitoring, and prevention. Ensures system protection.",
        downloadLink: "/scripts/Intrusion_Detection.sh",
      },
      {
        name: "Vulnerability Scanning",
        description: "System vulnerability scanning and assessment.",
        solution: "Implements vulnerability scanning, assessment, and reporting. Identifies security risks.",
        downloadLink: "/scripts/Vulnerability_Scanning.sh",
      },
      {
        name: "Security Monitoring",
        description: "Security monitoring and alerting system.",
        solution: "Implements security monitoring, alerting, and reporting. Ensures continuous security.",
        downloadLink: "/scripts/Security_Monitoring.sh",
      },
      {
        name: "Access Control",
        description: "Access control and authentication management.",
        solution: "Implements access control, authentication, and authorization. Ensures proper access management.",
        downloadLink: "/scripts/Access_Control.sh",
      },
      {
        name: "Security Compliance",
        description: "Security compliance and governance management.",
        solution: "Implements compliance checks, governance policies, and security standards. Ensures security compliance.",
        downloadLink: "/scripts/Security_Compliance.sh",
      },
      {
        name: "Security Backup",
        description: "Security configuration backup and recovery.",
        solution: "Implements security backup, configuration preservation, and restore procedures. Ensures security data safety.",
        downloadLink: "/scripts/Security_Backup.sh",
      },
      {
        name: "Security Optimization",
        description: "Security performance optimization and management.",
        solution: "Implements security optimization, performance tuning, and resource management. Ensures optimal security performance.",
        downloadLink: "/scripts/Security_Optimization.sh",
      },
      {
        name: "Security Audit",
        description: "Security audit and assessment management.",
        solution: "Implements security audit, assessment, and reporting. Ensures security compliance and effectiveness.",
        downloadLink: "/scripts/Security_Audit.sh",
      },
      {
        name: "Security Incident Response",
        description: "Security incident response and management.",
        solution: "Implements incident response, investigation, and resolution. Ensures quick and effective security incident handling.",
        downloadLink: "/scripts/Security_Incident_Response.sh",
      }
    ],
    'artificial intelligence': [
      {
        name: "Install TensorFlow",
        description: "Installs TensorFlow library for machine learning.",
        solution: "Installs TensorFlow library for machine learning.",
        downloadLink: "/scripts/Install_TensorFlow.sh",
      },
      {
        name: "Install PyTorch",
        description: "Installs PyTorch library for deep learning.",
        solution: "Installs PyTorch library for deep learning.",
        downloadLink: "/scripts/Install_PyTorch.sh",
      },
      {
        name: "Install Scikit-learn",
        description: "Installs Scikit-learn library for machine learning.",
        solution: "Installs Scikit-learn library for machine learning.",
        downloadLink: "/scripts/Install_Scikit_learn.sh",
      },
      {
        name: "Install Keras",
        description: "Installs Keras library for deep learning.",
        solution: "Installs Keras library for deep learning.",
        downloadLink: "/scripts/Install_Keras.sh",
      },
      {
        name: "Install OpenCV",
        description: "Installs OpenCV library for computer vision.",
        solution: "Installs OpenCV library for computer vision.",
        downloadLink: "/scripts/Install_OpenCV.sh",
      },
      {
        name: "Install NLTK",
        description: "Installs NLTK library for natural language processing.",
        solution: "Installs NLTK library for natural language processing.",
        downloadLink: "/scripts/Install_NLTK.sh",
      },
      {
        name: "Install Pandas",
        description: "Installs Pandas library for data manipulation.",
        solution: "Installs Pandas library for data manipulation.",
        downloadLink: "/scripts/Install_Pandas.sh",
      },
      {
        name: "Install NumPy",
        description: "Installs NumPy library for numerical computing.",
        solution: "Installs NumPy library for numerical computing.",
        downloadLink: "/scripts/Install_NumPy.sh",
      },
      {
        name: "Install Matplotlib",
        description: "Installs Matplotlib library for data visualization.",
        solution: "Installs Matplotlib library for data visualization.",
        downloadLink: "/scripts/Install_Matplotlib.sh",
      },
      {
        name: "Install Jupyter Notebook",
        description: "Installs Jupyter Notebook for interactive coding.",
        solution: "Installs Jupyter Notebook for interactive coding.",
        downloadLink: "/scripts/Install_Jupyter_Notebook.sh",
      },
      {
        name: "Install SpaCy",
        description: "Installs SpaCy library for natural language processing.",
        solution: "Installs SpaCy library for natural language processing.",
        downloadLink: "/scripts/Install_SpaCy.sh",
      },
      {
        name: "Check TensorFlow Version",
        description: "Checks the installed version of TensorFlow.",
        solution: "Checks the installed version of TensorFlow.",
        downloadLink: "/scripts/Check_TensorFlow_Version.sh",
      },
      {
        name: "Check PyTorch Version",
        description: "Checks the installed version of PyTorch.",
        solution: "Checks the installed version of PyTorch.",
        downloadLink: "/scripts/Check_PyTorch_Version.sh",
      },
      {
        name: "Run Basic TensorFlow Script",
        description: "Runs a basic TensorFlow script.",
        solution: "Runs a basic TensorFlow script.",
        downloadLink: "/scripts/Run_Basic_TensorFlow_Script.sh",
      },
      {
        name: "Run Basic PyTorch Script",
        description: "Runs a basic PyTorch script.",
        solution: "Runs a basic PyTorch script.",
        downloadLink: "/scripts/Run_Basic_PyTorch_Script.sh",
      },
      {
        name: "Train Scikit-learn Model",
        description: "Trains a machine learning model using Scikit-learn.",
        solution: "Trains a machine learning model using Scikit-learn.",
        downloadLink: "/scripts/Train_Scikit_Learn_Model.sh",
      },
      {
        name: "Create Basic Keras Neural Network",
        description: "Creates a basic neural network using Keras.",
        solution: "Creates a basic neural network using Keras.",
        downloadLink: "/scripts/Create_Basic_Keras_Neural_Network.sh",
      },
      {
        name: "Run OpenCV Computer Vision Script",
        description: "Runs a basic computer vision script using OpenCV.",
        solution: "Runs a basic computer vision script using OpenCV.",
        downloadLink: "/scripts/Run_OpenCV_Computer_Vision.sh",
      },
      {
        name: "Run SpaCy NLP Script",
        description: "Runs a natural language processing script using SpaCy.",
        solution: "Runs a natural language processing script using SpaCy.",
        downloadLink: "/scripts/Run_SpaCy_NLP_Script.sh",
      },
      {
        name: "Visualize Data with Matplotlib",
        description: "Visualizes data using Matplotlib.",
        solution: "Visualizes data using Matplotlib.",
        downloadLink: "/scripts/Visualize_Data_With_Matplotlib.sh",
      },
      {
        name: "Model Training",
        description: "AI model training and optimization.",
        solution: "Implements model training, optimization, and validation. Ensures proper model development.",
        downloadLink: "/scripts/Model_Training.sh",
      },
      {
        name: "Data Processing",
        description: "AI data processing and preparation.",
        solution: "Implements data processing, cleaning, and preparation. Ensures quality training data.",
        downloadLink: "/scripts/Data_Processing.sh",
      },
      {
        name: "Model Deployment",
        description: "AI model deployment and management.",
        solution: "Implements model deployment, monitoring, and management. Ensures proper model operation.",
        downloadLink: "/scripts/Model_Deployment.sh",
      },
      {
        name: "Performance Optimization",
        description: "AI model performance optimization.",
        solution: "Implements performance optimization, monitoring, and tuning. Improves model efficiency.",
        downloadLink: "/scripts/Performance_Optimization.sh",
      },
      {
        name: "Model Monitoring",
        description: "AI model monitoring and maintenance.",
        solution: "Implements model monitoring, maintenance, and updates. Ensures model reliability.",
        downloadLink: "/scripts/Model_Monitoring.sh",
      },
      {
        name: "Model Evaluation",
        description: "AI model evaluation and validation.",
        solution: "Implements model evaluation, validation, and performance analysis. Ensures model quality.",
        downloadLink: "/scripts/Model_Evaluation.sh",
      },
      {
        name: "Model Backup",
        description: "AI model backup and recovery.",
        solution: "Implements model backup, data preservation, and recovery procedures. Ensures model data safety.",
        downloadLink: "/scripts/Model_Backup.sh",
      },
      {
        name: "Model Optimization",
        description: "AI model optimization and management.",
        solution: "Implements model optimization, performance tuning, and resource management. Ensures optimal model performance.",
        downloadLink: "/scripts/Model_Optimization.sh",
      },
      {
        name: "Model Audit",
        description: "AI model audit and assessment.",
        solution: "Implements model audit, assessment, and reporting. Ensures model compliance and effectiveness.",
        downloadLink: "/scripts/Model_Audit.sh",
      },
      {
        name: "Model Incident Response",
        description: "AI model incident response and management.",
        solution: "Implements incident response, investigation, and resolution. Ensures quick and effective model incident handling.",
        downloadLink: "/scripts/Model_Incident_Response.sh",
      }
    ],
    'data science': [
      {
        name: "Data Analysis",
        description: "Data analysis and visualization.",
        solution: "Implements data analysis, visualization, and reporting. Provides insights from data.",
        downloadLink: "/scripts/Data_Analysis.sh",
      },
      {
        name: "Data Cleaning",
        description: "Data cleaning and preprocessing.",
        solution: "Implements data cleaning, preprocessing, and quality control. Ensures data quality.",
        downloadLink: "/scripts/Data_Cleaning.sh",
      },
      {
        name: "Statistical Analysis",
        description: "Statistical analysis and modeling.",
        solution: "Implements statistical analysis, modeling, and validation. Provides statistical insights.",
        downloadLink: "/scripts/Statistical_Analysis.sh",
      },
      {
        name: "Machine Learning",
        description: "Machine learning model development.",
        solution: "Implements machine learning, model training, and validation. Develops predictive models.",
        downloadLink: "/scripts/Machine_Learning.sh",
      },
      {
        name: "Data Visualization",
        description: "Data visualization and reporting.",
        solution: "Implements data visualization, reporting, and dashboard creation. Presents data effectively.",
        downloadLink: "/scripts/Data_Visualization.sh",
      },
      {
        name: "Data Validation",
        description: "Data validation and quality assurance.",
        solution: "Implements data validation, quality checks, and error detection. Ensures data accuracy.",
        downloadLink: "/scripts/Data_Validation.sh",
      },
      {
        name: "Data Backup",
        description: "Data backup and recovery.",
        solution: "Implements data backup, preservation, and recovery procedures. Ensures data safety.",
        downloadLink: "/scripts/Data_Backup.sh",
      },
      {
        name: "Data Optimization",
        description: "Data performance optimization and management.",
        solution: "Implements data optimization, performance tuning, and resource management. Ensures optimal data performance.",
        downloadLink: "/scripts/Data_Optimization.sh",
      },
      {
        name: "Data Audit",
        description: "Data audit and assessment.",
        solution: "Implements data audit, assessment, and reporting. Ensures data compliance and effectiveness.",
        downloadLink: "/scripts/Data_Audit.sh",
      },
      {
        name: "Data Incident Response",
        description: "Data incident response and management.",
        solution: "Implements incident response, investigation, and resolution. Ensures quick and effective data incident handling.",
        downloadLink: "/scripts/Data_Incident_Response.sh",
      }
    ],
    'web development': [
      {
        name: "Install Node.js",
        description: "Installs Node.js runtime environment.",
        solution: "Installs Node.js runtime environment.",
        downloadLink: "/scripts/Install_Nodejs.sh",
      },
      {
        name: "Install npm Packages",
        description: "Installs npm packages for your project.",
        solution: "Installs npm packages for your project.",
        downloadLink: "/scripts/Install_Npm_Packages.sh",
      },
      {
        name: "Install Express.js",
        description: "Installs Express.js framework for Node.js.",
        solution: "Installs Express.js framework for Node.js.",
        downloadLink: "/scripts/Install_Express.sh",
      },
      {
        name: "Install React",
        description: "Installs React framework for frontend development.",
        solution: "Installs React framework for frontend development.",
        downloadLink: "/scripts/Install_React.sh",
      },
      {
        name: "Install Angular",
        description: "Installs Angular framework for frontend development.",
        solution: "Installs Angular framework for frontend development.",
        downloadLink: "/scripts/Install_Angular.sh",
      },
      {
        name: "Install Vue.js",
        description: "Installs Vue.js framework for frontend development.",
        solution: "Installs Vue.js framework for frontend development.",
        downloadLink: "/scripts/Install_Vue.sh",
      },
      {
        name: "Install MongoDB",
        description: "Installs MongoDB NoSQL database.",
        solution: "Installs MongoDB NoSQL database.",
        downloadLink: "/scripts/Install_MongoDB.sh",
      },
      {
        name: "Install MySQL",
        description: "Installs MySQL database server.",
        solution: "Installs MySQL database server.",
        downloadLink: "/scripts/Install_MySQL.sh",
      },
      {
        name: "Install PostgreSQL",
        description: "Installs PostgreSQL database server.",
        solution: "Installs PostgreSQL database server.",
        downloadLink: "/scripts/Install_PostgreSQL.sh",
      },
      {
        name: "Install Nginx",
        description: "Installs Nginx web server.",
        solution: "Installs Nginx web server.",
        downloadLink: "/scripts/Install_Nginx.sh",
      },
      {
        name: "Start Node.js Server",
        description: "Starts the Node.js server.",
        solution: "Starts the Node.js server.",
        downloadLink: "/scripts/Start_Nodejs_Server.sh",
      },
      {
        name: "Start React Development Server",
        description: "Starts the React development server.",
        solution: "Starts the React development server.",
        downloadLink: "/scripts/Start_React_Development_Server.sh",
      },
      {
        name: "Start Angular Development Server",
        description: "Starts the Angular development server.",
        solution: "Starts the Angular development server.",
        downloadLink: "/scripts/Start_Angular_Development_Server.sh",
      },
      {
        name: "Start Vue Development Server",
        description: "Starts the Vue development server.",
        solution: "Starts the Vue development server.",
        downloadLink: "/scripts/Start_Vue_Development_Server.sh",
      },
      {
        name: "Start MongoDB Server",
        description: "Starts the MongoDB server.",
        solution: "Starts the MongoDB server.",
        downloadLink: "/scripts/Start_MongoDB_Server.sh",
      },
      {
        name: "Start MySQL Server",
        description: "Starts the MySQL server.",
        solution: "Starts the MySQL server.",
        downloadLink: "/scripts/Start_MySQL_Server.sh",
      },
      {
        name: "Start PostgreSQL Server",
        description: "Starts the PostgreSQL server.",
        solution: "Starts the PostgreSQL server.",
        downloadLink: "/scripts/Start_PostgreSQL_Server.sh",
      },
      {
        name: "Check Nginx Status",
        description: "Checks the status of the Nginx server.",
        solution: "Checks the status of the Nginx server.",
        downloadLink: "/scripts/Check_Nginx_Status.sh",
      },
      {
        name: "Check MongoDB Status",
        description: "Checks the status of the MongoDB server.",
        solution: "Checks the status of the MongoDB server.",
        downloadLink: "/scripts/Check_MongoDB_Status.sh",
      },
      {
        name: "Check MySQL Status",
        description: "Checks the status of the MySQL server.",
        solution: "Checks the status of the MySQL server.",
        downloadLink: "/scripts/Check_MySQL_Status.sh",
      },
      {
        name: "Web Server Setup",
        description: "Web server setup and configuration.",
        solution: "Implements web server setup, configuration, and optimization. Ensures proper web hosting.",
        downloadLink: "/scripts/Web_Server_Setup.sh",
      },
      {
        name: "SSL Configuration",
        description: "SSL certificate setup and management.",
        solution: "Implements SSL setup, renewal, and security. Ensures secure web communication.",
        downloadLink: "/scripts/SSL_Configuration.sh",
      },
      {
        name: "Performance Optimization",
        description: "Web application performance optimization.",
        solution: "Implements performance optimization, caching, and monitoring. Improves web performance.",
        downloadLink: "/scripts/Performance_Optimization.sh",
      },
      {
        name: "Security Hardening",
        description: "Web application security hardening.",
        solution: "Implements security hardening, vulnerability scanning, and protection. Ensures web security.",
        downloadLink: "/scripts/Security_Hardening.sh",
      },
      {
        name: "Deployment Automation",
        description: "Web application deployment automation.",
        solution: "Implements deployment automation, testing, and monitoring. Ensures smooth deployments.",
        downloadLink: "/scripts/Deployment_Automation.sh",
      }
    ],
    'mobile development': [
      {
        name: "Install Android Studio",
        description: "Installs Android Studio for mobile development.",
        solution: "Installs Android Studio for mobile development.",
        downloadLink: "/scripts/Install_Android_Studio.sh",
      },
      {
        name: "Install Flutter",
        description: "Installs Flutter framework for cross-platform development.",
        solution: "Installs Flutter framework for cross-platform development.",
        downloadLink: "/scripts/Install_Flutter.sh",
      },
      {
        name: "Install Xcode",
        description: "Installs Xcode for iOS development (macOS only).",
        solution: "Installs Xcode for iOS development (macOS only).",
        downloadLink: "/scripts/Install_Xcode.sh",
      },
      {
        name: "Install React Native CLI",
        description: "Installs React Native CLI for mobile development.",
        solution: "Installs React Native CLI for mobile development.",
        downloadLink: "/scripts/Install_React_Native_CLI.sh",
      },
      {
        name: "Install Android Emulator",
        description: "Installs Android Emulator for testing Android apps.",
        solution: "Installs Android Emulator for testing Android apps.",
        downloadLink: "/scripts/Install_Android_Emulator.sh",
      },
      {
        name: "Install iOS Emulator",
        description: "Installs iOS Emulator for testing iOS apps (macOS only).",
        solution: "Installs iOS Emulator for testing iOS apps (macOS only).",
        downloadLink: "/scripts/Install_IOS_Emulator.sh",
      },
      {
        name: "Install Node.js for Mobile",
        description: "Installs Node.js for mobile development.",
        solution: "Installs Node.js for mobile development.",
        downloadLink: "/scripts/Install_Nodejs_for_Mobile.sh",
      },
      {
        name: "Install CocoaPods",
        description: "Installs CocoaPods for managing iOS dependencies (macOS only).",
        solution: "Installs CocoaPods for managing iOS dependencies (macOS only).",
        downloadLink: "/scripts/Install_CocoaPods.sh",
      },
      {
        name: "Create Flutter Project",
        description: "Creates a new Flutter project.",
        solution: "Creates a new Flutter project.",
        downloadLink: "/scripts/Create_Flutter_Project.sh",
      },
      {
        name: "Create React Native Project",
        description: "Creates a new React Native project.",
        solution: "Creates a new React Native project.",
        downloadLink: "/scripts/Create_React_Native_Project.sh",
      },
      {
        name: "Run Android Emulator",
        description: "Runs the Android Emulator.",
        solution: "Runs the Android Emulator.",
        downloadLink: "/scripts/Run_Android_Emulator.sh",
      },
      {
        name: "Run iOS Emulator",
        description: "Runs the iOS Emulator (macOS only).",
        solution: "Runs the iOS Emulator (macOS only).",
        downloadLink: "/scripts/Run_IOS_Emulator.sh",
      },
      {
        name: "Build and Run Flutter Project",
        description: "Builds and runs a Flutter project.",
        solution: "Builds and runs a Flutter project.",
        downloadLink: "/scripts/Build_Run_Flutter_Project.sh",
      },
      {
        name: "Build and Run React Native Project",
        description: "Builds and runs a React Native project.",
        solution: "Builds and runs a React Native project.",
        downloadLink: "/scripts/Build_Run_React_Native_Project.sh",
      },
      {
        name: "Install Android SDK",
        description: "Installs the Android SDK.",
        solution: "Installs the Android SDK.",
        downloadLink: "/scripts/Install_Android_SDK.sh",
      },
      {
        name: "Install Xcode Command Line Tools",
        description: "Installs Xcode Command Line Tools (macOS only).",
        solution: "Installs Xcode Command Line Tools (macOS only).",
        downloadLink: "/scripts/Install_Xcode_CLT.sh",
      },
      {
        name: "Check Flutter Version",
        description: "Checks the installed version of Flutter.",
        solution: "Checks the installed version of Flutter.",
        downloadLink: "/scripts/Check_Flutter_Version.sh",
      },
      {
        name: "Check React Native Version",
        description: "Checks the installed version of React Native.",
        solution: "Checks the installed version of React Native.",
        downloadLink: "/scripts/Check_React_Native_Version.sh",
      },
      {
        name: "Check Android Emulator Status",
        description: "Checks the status of the Android Emulator.",
        solution: "Checks the status of the Android Emulator.",
        downloadLink: "/scripts/Check_Android_Emulator_Status.sh",
      },
      {
        name: "Check iOS Simulator Status",
        description: "Checks the status of the iOS Simulator (macOS only).",
        solution: "Checks the status of the iOS Simulator (macOS only).",
        downloadLink: "/scripts/Check_IOS_Simulator_Status.sh",
      },
      {
        name: "App Development",
        description: "Mobile app development environment setup.",
        solution: "Implements development environment setup, testing, and debugging. Ensures proper app development.",
        downloadLink: "/scripts/App_Development.sh",
      },
      {
        name: "Build Automation",
        description: "Mobile app build automation.",
        solution: "Implements build automation, testing, and deployment. Ensures consistent builds.",
        downloadLink: "/scripts/Build_Automation.sh",
      },
      {
        name: "Testing Framework",
        description: "Mobile app testing framework setup.",
        solution: "Implements testing framework, automation, and reporting. Ensures app quality.",
        downloadLink: "/scripts/Testing_Framework.sh",
      },
      {
        name: "Performance Optimization",
        description: "Mobile app performance optimization.",
        solution: "Implements performance optimization, monitoring, and tuning. Improves app performance.",
        downloadLink: "/scripts/Performance_Optimization.sh",
      },
      {
        name: "Security Implementation",
        description: "Mobile app security implementation.",
        solution: "Implements security measures, encryption, and protection. Ensures app security.",
        downloadLink: "/scripts/Security_Implementation.sh",
      }
    ],
    'game development': [
      {
        name: "Install Unity",
        description: "Installs Unity game engine.",
        solution: "Installs Unity game engine.",
        downloadLink: "/scripts/Install_Unity.sh",
      },
      {
        name: "Install Unreal Engine",
        description: "Installs Unreal Engine game engine.",
        solution: "Installs Unreal Engine game engine.",
        downloadLink: "/scripts/Install_Unreal_Engine.sh",
      },
      {
        name: "Install Godot",
        description: "Installs Godot game engine.",
        solution: "Installs Godot game engine.",
        downloadLink: "/scripts/Install_Godot.sh",
      },
      {
        name: "Install Visual Studio",
        description: "Installs Visual Studio for game development.",
        solution: "Installs Visual Studio for game development.",
        downloadLink: "/scripts/Install_Visual_Studio.sh",
      },
      {
        name: "Install Blender",
        description: "Installs Blender for 3D modeling.",
        solution: "Installs Blender for 3D modeling.",
        downloadLink: "/scripts/Install_Blender.sh",
      },
      {
        name: "Install GIMP",
        description: "Installs GIMP for image editing.",
        solution: "Installs GIMP for image editing.",
        downloadLink: "/scripts/Install_GIMP.sh",
      },
      {
        name: "Install Git",
        description: "Installs Git for version control.",
        solution: "Installs Git for version control.",
        downloadLink: "/scripts/Install_Git.sh",
      },
      {
        name: "Create Unity Project",
        description: "Creates a new Unity project.",
        solution: "Creates a new Unity project.",
        downloadLink: "/scripts/Create_Unity_Project.sh",
      },
      {
        name: "Create Unreal Project",
        description: "Creates a new Unreal Engine project.",
        solution: "Creates a new Unreal Engine project.",
        downloadLink: "/scripts/Create_Unreal_Project.sh",
      },
      {
        name: "Create Godot Project",
        description: "Creates a new Godot project.",
        solution: "Creates a new Godot project.",
        downloadLink: "/scripts/Create_Godot_Project.sh",
      },
      {
        name: "Build Unity Project",
        description: "Builds a Unity project.",
        solution: "Builds a Unity project.",
        downloadLink: "/scripts/Build_Unity_Project.sh",
      },
      {
        name: "Build Unreal Project",
        description: "Builds an Unreal Engine project.",
        solution: "Builds an Unreal Engine project.",
        downloadLink: "/scripts/Build_Unreal_Project.sh",
      },
      {
        name: "Build Godot Project",
        description: "Builds a Godot project.",
        solution: "Builds a Godot project.",
        downloadLink: "/scripts/Build_Godot_Project.sh",
      },
      {
        name: "Run Unity Project",
        description: "Runs a Unity project.",
        solution: "Runs a Unity project.",
        downloadLink: "/scripts/Run_Unity_Project.sh",
      },
      {
        name: "Run Unreal Project",
        description: "Runs an Unreal Engine project.",
        solution: "Runs an Unreal Engine project.",
        downloadLink: "/scripts/Run_Unreal_Project.sh",
      },
      {
        name: "Run Godot Project",
        description: "Runs a Godot project.",
        solution: "Runs a Godot project.",
        downloadLink: "/scripts/Run_Godot_Project.sh",
      },
      {
        name: "Install Unity Assets",
        description: "Installs assets from Unity Asset Store.",
        solution: "Installs assets from Unity Asset Store.",
        downloadLink: "/scripts/Install_Unity_Assets.sh",
      },
      {
        name: "Install Unreal Assets",
        description: "Installs assets from Unreal Engine Marketplace.",
        solution: "Installs assets from Unreal Engine Marketplace.",
        downloadLink: "/scripts/Install_Unreal_Assets.sh",
      },
      {
        name: "Create Unity Game Build",
        description: "Creates a game build in Unity.",
        solution: "Creates a game build in Unity.",
        downloadLink: "/scripts/Create_Unity_Game_Build.sh",
      },
      {
        name: "Create Unreal Game Build",
        description: "Creates a game build in Unreal Engine.",
        solution: "Creates a game build in Unreal Engine.",
        downloadLink: "/scripts/Create_Unreal_Game_Build.sh",
      },
      {
        name: "Game Engine Setup",
        description: "Game engine setup and configuration.",
        solution: "Implements game engine setup, configuration, and optimization. Ensures proper game development.",
        downloadLink: "/scripts/Game_Engine_Setup.sh",
      },
      {
        name: "Asset Management",
        description: "Game asset management and optimization.",
        solution: "Implements asset management, optimization, and version control. Ensures proper asset handling.",
        downloadLink: "/scripts/Asset_Management.sh",
      },
      {
        name: "Build System",
        description: "Game build system setup.",
        solution: "Implements build system, automation, and deployment. Ensures consistent builds.",
        downloadLink: "/scripts/Build_System.sh",
      },
      {
        name: "Performance Profiling",
        description: "Game performance profiling and optimization.",
        solution: "Implements performance profiling, monitoring, and optimization. Improves game performance.",
        downloadLink: "/scripts/Performance_Profiling.sh",
      },
      {
        name: "Testing Framework",
        description: "Game testing framework setup.",
        solution: "Implements testing framework, automation, and reporting. Ensures game quality.",
        downloadLink: "/scripts/Testing_Framework.sh",
      }
    ],
    'unsolved issues': [
      {
        name: "All databases menu",
        description: "Automated script to run all the databses.",
        solution: "Implements all the databses and gives us the menu to run using the docker containers.",
        downloadLink: "/scripts/All_Database.sh",
        innovation: "Uses memory dump analysis and automatic recovery procedures"
      },
      {
        name: "Cross-Distribution Driver Compatibility",
        description: "Ensures driver compatibility across different Linux distributions.",
        solution: "Implements universal driver loading mechanism with automatic compatibility checks and fallback options.",
        downloadLink: "/scripts/Cross_Distribution_Driver_Compatibility.sh",
        innovation: "Implements universal driver loading mechanism"
      },
      {
        name: "Real-time System Performance Optimization",
        description: "Dynamically optimizes system performance based on workload.",
        solution: "Uses machine learning to predict and prevent performance issues, automatically adjusting system parameters.",
        downloadLink: "/scripts/Real_Time_System_Performance_Optimization.sh",
        innovation: "Uses machine learning to predict and prevent performance issues"
      },
      {
        name: "Automatic Dependency Resolution",
        description: "Resolves complex dependency conflicts automatically.",
        solution: "Implements advanced dependency graph analysis with intelligent conflict resolution.",
        downloadLink: "/scripts/Automatic_Dependency_Resolution.sh",
        innovation: "Implements advanced dependency graph analysis"
      },
      {
        name: "Secure Driver Installation",
        description: "Ensures secure driver installation with integrity verification.",
        solution: "Uses blockchain for driver integrity verification and secure installation process.",
        downloadLink: "/scripts/Secure_Driver_Installation.sh",
        innovation: "Uses blockchain for driver integrity verification"
      },
      {
        name: "AI-Powered System Diagnostics",
        description: "Uses AI to diagnose and fix system issues automatically.",
        solution: "Implements machine learning for system diagnostics and automated problem resolution.",
        downloadLink: "/scripts/AI_System_Diagnostics.sh",
        innovation: "Implements machine learning for system diagnostics"
      },
      {
        name: "Cross-Platform Driver Compatibility",
        description: "Ensures driver compatibility across different platforms.",
        solution: "Uses universal driver abstraction layer for seamless cross-platform support.",
        downloadLink: "/scripts/Cross_Distribution_Driver_Compatibility.sh",
        innovation: "Uses universal driver abstraction layer"
      },
      {
        name: "Automatic Performance Tuning",
        description: "Automatically tunes system performance based on usage patterns.",
        solution: "Implements adaptive performance optimization with real-time monitoring.",
        downloadLink: "/scripts/Automatic_Performance_Tuning.sh",
        innovation: "Implements adaptive performance optimization"
      },
      {
        name: "Secure Boot Integration",
        description: "Ensures secure boot compatibility for all drivers.",
        solution: "Implements secure boot verification for all drivers with automatic signing.",
        downloadLink: "/scripts/Secure_Boot_Integration.sh",
        innovation: "Implements secure boot verification for all drivers"
      },
      {
        name: "Real-time System Monitoring",
        description: "Provides real-time system monitoring and alerting.",
        solution: "Uses predictive analytics for system monitoring and proactive issue prevention.",
        downloadLink: "/scripts/Real_Time_Monitoring.sh",
        innovation: "Uses predictive analytics for system monitoring"
      },
      {
        name: "Ubuntu Package Conflict Resolution",
        description: "Automatically resolves package conflicts and dependency issues.",
        solution: "Implements intelligent package conflict detection and resolution with minimal user intervention.",
        downloadLink: "/scripts/Package_Conflict_Resolution.sh",
        innovation: "Uses advanced package management algorithms"
      },
      {
        name: "System Recovery Automation",
        description: "Automated system recovery after critical failures.",
        solution: "Implements automatic system state backup and recovery with minimal downtime.",
        downloadLink: "/scripts/System_Recovery_Automation.sh",
        innovation: "Uses incremental backup and recovery techniques"
      },
      {
        name: "Hardware Compatibility Enhancement",
        description: "Improves hardware compatibility for unsupported devices.",
        solution: "Implements automatic hardware detection and driver compatibility layer.",
        downloadLink: "/scripts/Hardware_Compatibility_Enhancement.sh",
        innovation: "Uses hardware abstraction layer for better compatibility"
      },
      {
        name: "Network Configuration Optimization",
        description: "Optimizes network configuration for better performance.",
        solution: "Implements automatic network parameter tuning based on usage patterns.",
        downloadLink: "/scripts/Network_Configuration_Optimization.sh",
        innovation: "Uses adaptive network optimization algorithms"
      },
      {
        name: "System Resource Management",
        description: "Advanced system resource allocation and management.",
        solution: "Implements intelligent resource allocation with predictive load balancing.",
        downloadLink: "/scripts/System_Resource_Management.sh",
        innovation: "Uses predictive resource allocation algorithms"
      },
      {
        name: "Security Vulnerability Prevention",
        description: "Proactive security vulnerability prevention and mitigation.",
        solution: "Implements real-time security monitoring and automatic vulnerability patching.",
        downloadLink: "/scripts/Security_Vulnerability_Prevention.sh",
        innovation: "Uses AI-powered security analysis"
      },
      {
        name: "System Update Optimization",
        description: "Optimizes system updates for minimal disruption.",
        solution: "Implements intelligent update scheduling and rollback mechanisms.",
        downloadLink: "/scripts/System_Update_Optimization.sh",
        innovation: "Uses predictive update scheduling"
      },
      {
        name: "Disk Space Management",
        description: "Intelligent disk space management and optimization.",
        solution: "Implements automatic disk space analysis and cleanup with smart retention policies.",
        downloadLink: "/scripts/Disk_Space_Management.sh",
        innovation: "Uses machine learning for space optimization"
      },
      {
        name: "System Performance Profiling",
        description: "Advanced system performance profiling and optimization.",
        solution: "Implements comprehensive performance analysis with automatic optimization suggestions.",
        downloadLink: "/scripts/System_Performance_Profiling.sh",
        innovation: "Uses advanced performance profiling techniques"
      },
      {
        name: "User Environment Synchronization",
        description: "Synchronizes user environments across multiple systems.",
        solution: "Implements automatic environment backup and synchronization with conflict resolution.",
        downloadLink: "/scripts/User_Environment_Synchronization.sh",
        innovation: "Uses cloud-based environment synchronization"
      }
    ],
    devops: [
      {
        name: "Docker Container Optimization",
        description: "Optimizes Docker container performance and resource usage.",
        solution: "Optimizes Docker container performance and resource usage.",
        downloadLink: "/scripts/Docker_Container_Optimization.sh",
      },
      {
        name: "Kubernetes Cluster Setup",
        description: "Automates Kubernetes cluster setup and configuration.",
        solution: "Automates Kubernetes cluster setup and configuration.",
        downloadLink: "/scripts/Kubernetes_Cluster_Setup.sh",
      },
      {
        name: "CI/CD Pipeline Setup",
        description: "Sets up a complete CI/CD pipeline with GitHub Actions.",
        solution: "Sets up a complete CI/CD pipeline with GitHub Actions.",
        downloadLink: "/scripts/CI_CD_Pipeline_Setup.sh",
      },
      {
        name: "Infrastructure as Code (Terraform)",
        description: "Creates and manages cloud infrastructure using Terraform.",
        solution: "Creates and manages cloud infrastructure using Terraform.",
        downloadLink: "/scripts/Terraform_Infrastructure.sh",
      },
      {
        name: "Log Management Setup",
        description: "Sets up centralized log management with ELK stack.",
        solution: "Sets up centralized log management with ELK stack.",
        downloadLink: "/scripts/Log_Management_Setup.sh",
      },
      {
        name: "Monitoring System Setup",
        description: "Configures Prometheus and Grafana for system monitoring.",
        solution: "Configures Prometheus and Grafana for system monitoring.",
        downloadLink: "/scripts/Monitoring_System_Setup.sh",
      },
      {
        name: "Auto-scaling Configuration",
        description: "Sets up auto-scaling for cloud resources.",
        solution: "Sets up auto-scaling for cloud resources.",
        downloadLink: "/scripts/Auto_scaling_Configuration.sh",
      },
      {
        name: "Security Hardening",
        description: "Implements security best practices for DevOps environments.",
        solution: "Implements security best practices for DevOps environments.",
        downloadLink: "/scripts/Security_Hardening.sh",
      },
      {
        name: "Backup Automation",
        description: "Automates backup processes for critical systems.",
        solution: "Automates backup processes for critical systems.",
        downloadLink: "/scripts/Backup_Automation.sh",
      },
      {
        name: "Disaster Recovery Setup",
        description: "Configures disaster recovery procedures.",
        solution: "Configures disaster recovery procedures.",
        downloadLink: "/scripts/Disaster_Recovery_Setup.sh",
      },
      {
        name: "Container Security Scan",
        description: "Performs security scanning for Docker containers.",
        solution: "Performs security scanning for Docker containers.",
        downloadLink: "/scripts/Container_Security_Scan.sh",
      },
      {
        name: "Performance Testing Setup",
        description: "Sets up automated performance testing environment.",
        solution: "Sets up automated performance testing environment.",
        downloadLink: "/scripts/Performance_Testing_Setup.sh",
      },
      {
        name: "Configuration Management",
        description: "Manages system configurations using Ansible.",
        solution: "Manages system configurations using Ansible.",
        downloadLink: "/scripts/Configuration_Management.sh",
      },
      {
        name: "Service Mesh Setup",
        description: "Configures Istio service mesh for microservices.",
        solution: "Configures Istio service mesh for microservices.",
        downloadLink: "/scripts/Service_Mesh_Setup.sh",
      },
      {
        name: "Database Migration",
        description: "Automates database migration processes.",
        solution: "Automates database migration processes.",
        downloadLink: "/scripts/Database_Migration.sh",
      },
      {
        name: "Load Balancer Configuration",
        description: "Sets up and configures load balancers.",
        solution: "Sets up and configures load balancers.",
        downloadLink: "/scripts/Load_Balancer_Configuration.sh",
      },
      {
        name: "Secret Management",
        description: "Implements secure secret management.",
        solution: "Implements secure secret management.",
        downloadLink: "/scripts/Secret_Management.sh",
      },
      {
        name: "Infrastructure Monitoring",
        description: "Sets up comprehensive infrastructure monitoring.",
        solution: "Sets up comprehensive infrastructure monitoring.",
        downloadLink: "/scripts/Infrastructure_Monitoring.sh",
      },
      {
        name: "Automated Testing Setup",
        description: "Configures automated testing environment.",
        solution: "Configures automated testing environment.",
        downloadLink: "/scripts/Automated_Testing_Setup.sh",
      },
      {
        name: "DevOps Environment Setup",
        description: "Sets up complete DevOps development environment.",
        solution: "Sets up complete DevOps development environment.",
        downloadLink: "/scripts/DevOps_Environment_Setup.sh",
      }
    ],
    blockchain: [
      {
        name: "Ethereum Node Setup",
        description: "Sets up and configures an Ethereum node.",
        solution: "Sets up and configures an Ethereum node.",
        downloadLink: "/scripts/Ethereum_Node_Setup.sh",
      },
      {
        name: "Smart Contract Deployment",
        description: "Automates smart contract deployment process.",
        solution: "Automates smart contract deployment process.",
        downloadLink: "/scripts/Smart_Contract_Deployment.sh",
      },
      {
        name: "Blockchain Network Monitoring",
        description: "Sets up monitoring for blockchain networks.",
        solution: "Sets up monitoring for blockchain networks.",
        downloadLink: "/scripts/Blockchain_Network_Monitoring.sh",
      },
      {
        name: "Wallet Security Setup",
        description: "Configures secure wallet management.",
        solution: "Configures secure wallet management.",
        downloadLink: "/scripts/Wallet_Security_Setup.sh",
      },
      {
        name: "Transaction Monitoring",
        description: "Sets up transaction monitoring and analysis.",
        solution: "Sets up transaction monitoring and analysis.",
        downloadLink: "/scripts/Transaction_Monitoring.sh",
      },
      {
        name: "Blockchain Explorer Setup",
        description: "Configures blockchain explorer for network analysis.",
        solution: "Configures blockchain explorer for network analysis.",
        downloadLink: "/scripts/Blockchain_Explorer_Setup.sh",
      },
      {
        name: "Node Synchronization",
        description: "Manages blockchain node synchronization.",
        solution: "Manages blockchain node synchronization.",
        downloadLink: "/scripts/Node_Synchronization.sh",
      },
      {
        name: "Smart Contract Testing",
        description: "Sets up automated testing for smart contracts.",
        solution: "Sets up automated testing for smart contracts.",
        downloadLink: "/scripts/Smart_Contract_Testing.sh",
      },
      {
        name: "Blockchain Backup",
        description: "Automates blockchain data backup procedures.",
        solution: "Automates blockchain data backup procedures.",
        downloadLink: "/scripts/Blockchain_Backup.sh",
      },
      {
        name: "Network Security Setup",
        description: "Configures security measures for blockchain networks.",
        solution: "Configures security measures for blockchain networks.",
        downloadLink: "/scripts/Network_Security_Setup.sh",
      },
      {
        name: "Consensus Algorithm Setup",
        description: "Configures consensus algorithms for blockchain networks.",
        solution: "Configures consensus algorithms for blockchain networks.",
        downloadLink: "/scripts/Consensus_Algorithm_Setup.sh",
      },
      {
        name: "Blockchain API Setup",
        description: "Sets up APIs for blockchain interaction.",
        solution: "Sets up APIs for blockchain interaction.",
        downloadLink: "/scripts/Blockchain_API_Setup.sh",
      },
      {
        name: "Token Deployment",
        description: "Automates token deployment process.",
        solution: "Automates token deployment process.",
        downloadLink: "/scripts/Token_Deployment.sh",
      },
      {
        name: "Blockchain Analytics",
        description: "Sets up analytics for blockchain data.",
        solution: "Sets up analytics for blockchain data.",
        downloadLink: "/scripts/Blockchain_Analytics.sh",
      },
      {
        name: "Network Performance Optimization",
        description: "Optimizes blockchain network performance.",
        solution: "Optimizes blockchain network performance.",
        downloadLink: "/scripts/Network_Performance_Optimization.sh",
      },
      {
        name: "Smart Contract Security Audit",
        description: "Performs security audits on smart contracts.",
        solution: "Performs security audits on smart contracts.",
        downloadLink: "/scripts/Smart_Contract_Security_Audit.sh",
      },
      {
        name: "Blockchain Integration",
        description: "Sets up blockchain integration with existing systems.",
        solution: "Sets up blockchain integration with existing systems.",
        downloadLink: "/scripts/Blockchain_Integration.sh",
      },
      {
        name: "Node Health Monitoring",
        description: "Monitors health of blockchain nodes.",
        solution: "Monitors health of blockchain nodes.",
        downloadLink: "/scripts/Node_Health_Monitoring.sh",
      },
      {
        name: "Transaction Fee Optimization",
        description: "Optimizes transaction fees for blockchain operations.",
        solution: "Optimizes transaction fees for blockchain operations.",
        downloadLink: "/scripts/Transaction_Fee_Optimization.sh",
      },
      {
        name: "Blockchain Scaling Solution",
        description: "Implements scaling solutions for blockchain networks.",
        solution: "Implements scaling solutions for blockchain networks.",
        downloadLink: "/scripts/Blockchain_Scaling_Solution.sh",
      }
    ]
  };

  // Get scripts for the current category
  const scripts = allScripts[category.toLowerCase()] || [];

  // Filter scripts based on search query
  const filteredScripts = scripts.filter(script => {
    const searchLower = searchQuery.toLowerCase();
    return (
      script.name.toLowerCase().includes(searchLower) ||
      script.description.toLowerCase().includes(searchLower)
    );
  });

  return (
    <div className="category-page">
      <h1 className="category-title">{category} Scripts</h1>
      <div className="search-container">
        <input
          type="text"
          placeholder="Search scripts..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="search-input"
        />
      </div>
      <div className="scripts-container">
        {filteredScripts.length > 0 ? (
          filteredScripts.map((script) => (
            <div key={script.name} className="script-card">
              <h3 className="script-name">{script.name}</h3>
              <p className="script-description">{script.description}</p>
              {script.solution && (
                <div className="solution-section">
                  <h4>Solution</h4>
                  <p>{script.solution}</p>
                </div>
              )}
              {script.author && (
                <div className="author-section">
                  <h4>Author</h4>
                  <p>{script.author}</p>
                </div>
              )}
              {script.innovation && (
                <div className="innovation-section">
                  <h4>Innovation</h4>
                  <p>{script.innovation}</p>
                </div>
              )}
              <a
                href={script.downloadLink}
                className="download-button"
                download
              >
                Download
              </a>
            </div>
          ))
        ) : (
          <p>No scripts found matching your search.</p>
        )}
      </div>
    </div>
  );
};

export default CategoryPage;