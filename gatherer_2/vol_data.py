import wmi
import json

def get_processes(output_file)
    processes = wmi.WMI ()
    process_list = []

    for process in processes.Win32_Process ():
      data = { 'name': process.Name,
             'pid': process.ProcessId,
             'ppid': process.ParentProcessID,
             'path': process.ExecutablePath,
             'cmdline': process.CommandLine }

      process_list.append(data)


    with open(output_file,'w') as oetutfile:
        for i in process_list:
            json.dump(i, outfile)

if __name__ == "__main__":
    get_processes("processes.json")

