# Ускоряем Apache.JMeter

## HTTP Sampler с максимальной интенсивностью

Цель данной статьи — добиться максимальной интенсивности компонента **HTTP Sampler** в **Apache.JMeter** 5.1.1. На тесте загрузки страницы по умолчанию в **nginx**.

Оценить влияние:

* настроек **HTTP Sampler**;
* настроек **Apache.JMeter**;
* настроек операционной системы **Ubuntu Linux**;
* структуры тестового сценария.

Дополнительная цель:

* выявить узкие места;
* устранить узкие места.

### Тестовый стенд — локальный nginx

### Влияние keepalive на HTTP Sampler

#### HTTP Sampler без keep alive

#### HTTP Sampler x1

#### HTTP Sampler x10

#### HTTP Sampler x100

#### HTTP Sampler с переиспользованием подключения

#### Результаты (keepalive)

#### Профилирование SJK

#### Профилирование JFR

#### Профилирование jVisualVM

### Влияние количества потоков на HTTP Sampler

#### Один поток

##### Один поток и HTTP Sampler без keep alive

##### Один поток и HTTP Sampler x10

##### Один поток и HTTP Sampler x100

##### Один поток и HTTP Sampler с переиспользованием подключения

#### Два потока

##### Два потока и HTTP Sampler без keep alive

##### Два потока и HTTP Sampler x10

##### Два потока и HTTP Sampler x100

##### Два потока и HTTP Sampler с переиспользованием подключения

#### Три потока

##### Три потока и HTTP Sampler без keep alive

##### Три потока и HTTP Sampler x10

##### Три потока и HTTP Sampler x100

##### Три потока и HTTP Sampler с переиспользованием подключения

#### Результаты (потоки)

### Влияние настроек Ubuntu Linux

Текущая версия Ubuntu Linux: 18.04.2 LTS. Версия ядра: 4.15.0-47-generic. Для x86_64.

```
$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.2 LTS
Release:    18.04
Codename:   bionic

$ uname -r
4.15.0-47-generic

$ uname -p
x86_64
```

#### Рекомендации для Gatling

<https://gatling.io/docs/current/general/operations/>

##### IPv4 vs IPv6

##### OS Tuning. Open Files Limit

<https://github.com/basho/basho_docs/blob/master/content/riak/kv/2.2.3/using/performance/open-files-limit.md/>

```
ulimit -n 200000
```

##### OS Tuning. Kernel and Network Tuning

Рекомендованные настройки для сервера Basho:

<https://github.com/basho/basho_docs/blob/master/content/riak/kv/2.2.3/using/performance.md#kernel-and-network-tuning>

```
net.ipv4.tcp_max_syn_backlog = 40000
net.core.somaxconn = 40000
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_moderate_rcvbuf = 1
```

```
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_mem  = 134217728 134217728 134217728
net.ipv4.tcp_rmem = 4096 277750 134217728
net.ipv4.tcp_wmem = 4096 277750 134217728
net.core.netdev_max_backlog = 300000
```

#### Рекомендации для Yandex.Tank

Рекомендованные настройки для клиента Yandex.Tank:

<https://yandextank.readthedocs.io/en/develop/generator_tuning.html#tuning>

```
ulimit -n 30000

net.ipv4.tcp_max_tw_buckets = 65536
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_max_syn_backlog = 131072
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_synack_retries = 3
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_rmem = 16384 174760 349520
net.ipv4.tcp_wmem = 16384 131072 262144
net.ipv4.tcp_mem = 262144 524288 1048576
net.ipv4.tcp_max_orphans = 65536
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_syncookies = 0
net.netfilter.nf_conntrack_max = 1048576
```


##### Значения по умолчанию для Ubuntu

```
cat /proc/1/limits
```
|Limit                 |Soft Limit  |Hard Limit  |Units|
|---|---|---|---| 
|Max cpu time          |unlimited   |unlimited   |seconds|
|Max file size         |unlimited   |unlimited   |bytes|
|Max data size         |unlimited   |unlimited   |bytes|
|Max stack size        |8388608     |unlimited   |bytes|
|Max core file size    |0           |unlimited   |bytes|
|Max resident set      |unlimited   |unlimited   |bytes|
|Max processes         |31164       |31164       |processes |
|Max open files        |1048576     |1048576     |files|
|Max locked memory     |16777216    |16777216    |bytes|
|Max address space     |unlimited   |unlimited   |bytes|
|Max file locks        |unlimited   |unlimited   |locks|
|Max pending signals   |31164       |31164       |signals|
|Max msgqueue size     |819200      |819200      |bytes|   
|Max nice priority     |0           |0           ||
|Max realtime priority |0           |0           ||
|Max realtime timeout  |unlimited   |unlimited   |us|

Другие настройки получены, используя команду `sysctl` и `grep`, например:

```
sysctl -a | grep net.ipv4.tcp_max_syn_backlog
```

##### Таблица рекомендаций для Gatling и Yandex.Tank



| Настройка                         | Gatling   |Yandex.Tank| Ubuntu    |
|---|---|---|---|
| `ulimit -n` (open files)          | 200000    | 30000     | 1024      |
| `ulimit -Hn` (open files)         | 200000    |           | 4096      |
| `ulimit -Sn` (open files)         | 65536     |           | 1024      |
| `ulimit -Si` (pending signals)    |           |           | 31164     |
| `ulimit -Hi` (pending signals)    |           |           | 31164     |
| `ulimit -Su` (processes)          |           |           | 31164     |
| `ulimit -Hu` (processes)          |           |           | 31164     |
| net.ipv4.tcp_max_syn_backlog      | 40000     | 131072    | 256       |
| net.ipv4.tcp_rmem                 | 4096 277750 134217728 | 16384 174760 349520 | 4096	87380	6291456 |
| net.ipv4.tcp_wmem                 | 4096 277750 134217728 | 16384 131072 262144 | 4096	16384	4194304 |
| net.ipv4.tcp_mem                  | 134217728 134217728 134217728 | 262144 524288 1048576 | 92796	123731	185592 |
| net.ipv4.tcp_fin_timeout          | 15        | 10        | 60        |
| net.ipv4.tcp_tw_reuse             | 1         | 0         | 0         |
| net.ipv4.tcp_max_tw_buckets       |           | 65536     | 32768     |
| net.ipv4.tcp_tw_recycle           |           | 1         | ---       |
| net.ipv4.tcp_syn_retries          |           | 3         | 6         |
| net.ipv4.tcp_synack_retries       |           | 3         | 5         |
| net.ipv4.tcp_retries1             |           | 3         | 3         |
| net.ipv4.tcp_retries2             |           | 8         | 15        |
| net.ipv4.tcp_max_orphans          |           | 65536     | 32768     |
| net.ipv4.tcp_low_latency          |           | 1         | 0         |
| net.ipv4.tcp_syncookies           |           | 0         | 1         |
| net.netfilter.nf_conntrack_max    |           | 1048576   | ---       |
| net.core.somaxconn                | 40000     |           | 128       |
| net.core.wmem_default             | 8388608   |           | 212992    |
| net.core.rmem_default             | 8388608   |           | 212992    |
| net.ipv4.tcp_sack                 | 1         |           | 1         |
| net.ipv4.tcp_window_scaling       | 1         |           | 1         |
| net.ipv4.tcp_keepalive_intvl      | 30        |           | 75        |
| net.ipv4.tcp_moderate_rcvbuf      | 1         |           | 1         |
| net.core.rmem_max                 | 134217728 |           | 212992    |
| net.core.wmem_max                 | 134217728 |           | 212992    |
| net.core.netdev_max_backlog       | 300000    |           | 1000      |


##### ulimit (200000, 30000)
было 1024 стало 20000
не влияет на количество ошибок

##### net.ipv4.tcp_max_syn_backlog (40000, 131072)

##### net.core.wmem_default (8388608, default)

##### net.core.rmem_default (8388608, default)

##### net.ipv4.tcp_sack (1, default)

##### net.ipv4.tcp_window_scaling (1, default)

##### net.core.somaxconn
было 128 стало 40000
Не влияет на количество ошибок

##### net.ipv4.tcp_fin_timeout
было 60 стало 10
Не влияет на количество ошибок

##### net.ipv4.tcp_max_tw_buckets
-


