# stressapptest

Different ways to trigger OOMs

# 1) Memtest directly
```bash
# Uncomment in `deployment.yaml`
# command: [ "/memtest" ] # Run the OOM trigger directly
kubectl apply -f deployment.yaml

kubectl logs deployments/bash
got 1 MiB
...
got 64281 MiB

kubectl get pods
NAME                    READY   STATUS      RESTARTS      AGE
bash-5f94b5d85f-4wjhh   0/1     OOMKilled   1 (24s ago)   44s

kubectl describe pods/bash-5f94b5d85f-4wjhh
...
  Command:
    /memtest
  State:          Waiting
    Reason:       CrashLoopBackOff
  Last State:     Terminated
    Reason:       OOMKilled
    Exit Code:    137
    Started:      Mon, 08 May 2023 21:40:43 -0400
    Finished:     Mon, 08 May 2023 21:41:00 -0400
...
```

# 2) Memtest bash
Notice the script never exits, restarts stay 0, 
```bash
# Uncomment in `deployment.yaml`
# command: [ "bash","script-memtest.sh" ] # Run the OOM in a bg job
kubectl apply -f deployment.yaml

kubectl logs deployments/bash
Running memtest via the script...
Sleeping for remainder of time...
got 1 MiB
...
got 63987 MiB
got 63988 MiB
...

NAME                    READY   STATUS    RESTARTS   AGE
bash-7787c5c59f-v8lxg   1/1     Running   0          77s

    Command:
      bash
      script-memtest.sh
    State:          Running
      Started:      Mon, 08 May 2023 21:43:59 -0400
    Ready:          True
    Restart Count:  0

[3779693.592735] Tasks state (memory values in pages):
[3779693.592736] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
[3779693.592742] [   4426]     0  4426     1088      764    45056       62          -997 bash
[3779693.592745] [   4451]     0  4451 16495465      331 132259840    64207          -997 memtest
[3779693.592748] [   4452]     0  4452      695      239    40960       23          -997 sleep
[3779693.592751] oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=kubepods-pod7e0223ca_277f_468e_b2a1_76c5497918b8.slice:cri-containerd:85acf91df4e6ada8ad3603904b133c236899516668565c7ef5e5d7fb25011731,mems_allowed=0-1,oom_memcg=/system.slice/k3s-agent.service/kubepods-pod7e0223ca_277f_468e_b2a1_76c5497918b8.slice:cri-containerd:85acf91df4e6ada8ad3603904b133c236899516668565c7ef5e5d7fb25011731,task_memcg=/system.slice/k3s-agent.service/kubepods-pod7e0223ca_277f_468e_b2a1_76c5497918b8.slice:cri-containerd:85acf91df4e6ada8ad3603904b133c236899516668565c7ef5e5d7fb25011731,task=memtest,pid=4451,uid=0
[3779693.592768] Memory cgroup out of memory: Killed process 4451 (memtest) total-vm:65981860kB, anon-rss:0kB, file-rss:1324kB, shmem-rss:0kB, UID:0 pgtables:129160kB oom_score_adj:-997
```
