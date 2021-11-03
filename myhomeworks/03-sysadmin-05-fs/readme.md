## Домашнее задание к занятию "3.5. Файловые системы"

1. _Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах._
> Sparse-файлы (разреженные) – это специальные файлы, которые с большей эффективностью используют файловую систему, 
    они не позволяют ФС занимать свободное дисковое пространство носителя, когда разделы не заполнены. 
    То есть, «пустое место» будет задействовано только при необходимости. Пустая информация в виде нулей, 
    будет хранится в блоке метаданных ФС. Поэтому, разреженные файлы изначально занимают меньший объем носителя, 
    чем их реальный объем.  
> Команды linux для создания sparse-файла: `dd` или `trancate`.  
> Пример: `truncate -s10G file-sparse`, команда создаст разреженный файл file-sparse размером 10 гигабайт.

2. _Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?_
> Ответ скрывается в вопросе :)  Не могут, т.к. указывают на один и тот же объект на физическом диске (идентичный inode), у которого может быть только один владелец и права для пользователей.  
> Можно проверить, изменив у одного из хардлинков файла владельца и/или права доступа. При проверке `stat` у всех остальных хардлинков, указывающих на физический файл с таким же inode, будут идентичные владелец и права.  
> Для разделения прав на один и тот же объект можно использовать симлинки.  
3. _Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:_

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    _Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб._

4. _Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство._
```
Command (m for help): g
Created a new GPT disklabel (GUID: 4DFF4FDC-07FA-F446-BE9F-72B35E8ED34F).

Command (m for help): n
Partition number (1-128, default 1): 1
First sector (2048-5242846, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242846, default 5242846): +2G

Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.

Command (m for help): n
Partition number (2-128, default 2): 
First sector (4196352-5242846, default 4196352): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242846, default 5242846): 

Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

5. _Используя `sfdisk`, перенесите данную таблицу разделов на второй диск._
```
root@vagrant:/home# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk 
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part 
└─sda5                 8:5    0 63.5G  0 part 
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk 
├─sdb1                 8:17   0    2G  0 part 
└─sdb2                 8:18   0  511M  0 part 
sdc                    8:32   0  2.5G  0 disk 
├─sdc1                 8:33   0    2G  0 part 
└─sdc2                 8:34   0  511M  0 part 
```

6. _Соберите `mdadm` RAID1 на паре разделов 2 Гб._
```
root@vagrant:/home# mdadm -Cv /dev/md1 -l 1 -n 2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
root@vagrant:/home# 
root@vagrant:/home# 
root@vagrant:/home# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md1 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]
      
unused devices: <none>
```

7. _Соберите `mdadm` RAID0 на второй паре маленьких разделов._
```
root@vagrant:/home# mdadm -Cv /dev/md2 -l 0 -n 2 /dev/sdb2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started.
root@vagrant:/home# 
root@vagrant:/home# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md2 : active raid0 sdc2[1] sdb2[0]
      1041408 blocks super 1.2 512k chunks
      
md1 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]
      
unused devices: <none>
```
8. _Создайте 2 независимых PV на получившихся md-устройствах._
```
root@vagrant:/home# pvcreate /dev/md1 /dev/md2
  Physical volume "/dev/md1" successfully created.
  Physical volume "/dev/md2" successfully created.
root@vagrant:/home# pvscan
  PV /dev/sda5   VG vgvagrant       lvm2 [<63.50 GiB / 0    free]
  PV /dev/md1                       lvm2 [<2.00 GiB]
  PV /dev/md2                       lvm2 [1017.00 MiB]
  Total: 3 [<66.49 GiB] / in use: 1 [<63.50 GiB] / in no VG: 2 [2.99 GiB]
```
9. _Создайте общую volume-group на этих двух PV._
```
root@vagrant:/home# vgcreate VG12 /dev/md1 /dev/md2
  Volume group "VG12" successfully created
root@vagrant:/home# vgscan 
  Found volume group "vgvagrant" using metadata type lvm2
  Found volume group "VG12" using metadata type lvm2
root@vagrant:/home# 
```
10. _Создайте LV размером 100 Мб, указав его расположение на PV с RAID0._
```
root@vagrant:/home# lvcreate -L100 -nLV100_RAID0 VG12 /dev/md2
  Logical volume "LV100_RAID0" created.
root@vagrant:/home# lvscan 
  ACTIVE            '/dev/vgvagrant/root' [<62.54 GiB] inherit
  ACTIVE            '/dev/vgvagrant/swap_1' [980.00 MiB] inherit
  ACTIVE            '/dev/VG12/LV100_RAID0' [100.00 MiB] inherit
```
11. _Создайте `mkfs.ext4` ФС на получившемся LV._
```
root@vagrant:/home# mkfs.ext4 /dev/VG12/LV100_RAID0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```
12. _Смонтируйте этот раздел в любую директорию, например, `/tmp/new`._
```
root@vagrant:/home/vagrant# mount /dev/VG12/LV100_RAID0 /home/vagrant/my_raid0/
root@vagrant:/home/vagrant# mount -l | grep my_raid
/dev/mapper/VG12-LV100_RAID0 on /home/vagrant/my_raid0 type ext4 (rw,relatime,stripe=256)
```
13. _Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`._
```
root@vagrant:/home/vagrant# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /home/vagrant/my_raid0/test.gz
--2021-11-03 20:20:08--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22176643 (21M) [application/octet-stream]
Saving to: ‘/home/vagrant/my_raid0/test.gz’

/home/vagrant/my_raid0/test.gz     100%[=============================================================>]  21.15M  20.6MB/s    in 1.0s    

2021-11-03 20:20:10 (20.6 MB/s) - ‘/home/vagrant/my_raid0/test.gz’ saved [22176643/22176643]
```
14. _Прикрепите вывод `lsblk`._
```
root@vagrant:/home/vagrant# lsblk
NAME                   MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                      8:0    0   64G  0 disk  
├─sda1                   8:1    0  512M  0 part  /boot/efi
├─sda2                   8:2    0    1K  0 part  
└─sda5                   8:5    0 63.5G  0 part  
  ├─vgvagrant-root     253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1   253:1    0  980M  0 lvm   [SWAP]
sdb                      8:16   0  2.5G  0 disk  
├─sdb1                   8:17   0    2G  0 part  
│ └─md1                  9:1    0    2G  0 raid1 
└─sdb2                   8:18   0  511M  0 part  
  └─md2                  9:2    0 1017M  0 raid0 
    └─VG12-LV100_RAID0 253:2    0  100M  0 lvm   /home/vagrant/my_raid0
sdc                      8:32   0  2.5G  0 disk  
├─sdc1                   8:33   0    2G  0 part  
│ └─md1                  9:1    0    2G  0 raid1 
└─sdc2                   8:34   0  511M  0 part  
  └─md2                  9:2    0 1017M  0 raid0 
    └─VG12-LV100_RAID0 253:2    0  100M  0 lvm   /home/vagrant/my_raid0
```
15. _Протестируйте целостность файла:_
```
root@vagrant:/home/vagrant# gzip -t my_raid0/test.gz && echo $?
0
```
16. _Используя pvmove, переместите содержимое PV с RAID0 на RAID1._
```
root@vagrant:/home/vagrant# pvmove /dev/md2 /dev/md1
  /dev/md2: Moved: 12.00%
  /dev/md2: Moved: 100.00%
```
17. _Сделайте `--fail` на устройство в вашем RAID1 md._
```
root@vagrant:/home/vagrant# mdadm --fail /dev/md1 /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md1
```
18. _Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии._
```
root@vagrant:/home/vagrant# dmesg | grep -i raid1
[14523.369066] md/raid1:md1: not clean -- starting background reconstruction
[14523.369082] md/raid1:md1: active with 2 out of 2 mirrors
[25150.311795] md/raid1:md1: Disk failure on sdc1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
```
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
```
root@vagrant:/home/vagrant# cat /proc/mdstat && gzip -t my_raid0/test.gz && echo 'Код теста:'$?
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md2 : active raid0 sdc2[1] sdb2[0]
      1041408 blocks super 1.2 512k chunks
      
md1 : active raid1 sdc1[1](F) sdb1[0]
      2094080 blocks super 1.2 [2/1] [U_]
      
unused devices: <none>
Код теста:0
```