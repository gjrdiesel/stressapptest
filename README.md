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
```bash
# <todo>
```

# 3) Memtest2 directly
```bash
# <todo>
```

# 4) Memtest2 script
```bash
# <todo>
```
