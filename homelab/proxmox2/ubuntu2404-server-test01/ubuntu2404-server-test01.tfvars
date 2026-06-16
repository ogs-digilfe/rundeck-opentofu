# ubuntu2404-server-test01.tfvars
# proxmoxのvm idの指定
vm_id = 10070

# poroxmoxが管理するときのこのVMのvm名
vm_name = "ubuntu2404-server-test01"

# proxmoxで作成したtemplate仮想マシンのvm id
template_vm_id = 9100

# この仮想マシンのvcpuコア数
vm_cores = 2

# この仮想マシンのメモリ容量(GiB)
vm_memory = 4096

# この仮想マシンのストレージ容量(MiB)
vm_disk_size = 32

#　このVMに付与する固定ipアドレス
vm_ip = "192.168.0.70"

# このvmの接続先NW(ブリッジ)
vm_bridge = "vmbr0"






