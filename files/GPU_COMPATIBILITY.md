# GPU Compatibility Guide for Nomad

This guide explains how to work with GPU and non-GPU workloads in Nomad.

## GPU Detection

The Ansible playbook automatically detects NVIDIA GPUs on client nodes and configures them appropriately. If a GPU is detected:

1. NVIDIA drivers are installed
2. NVIDIA Container Toolkit is installed
3. Docker is configured to use the NVIDIA runtime
4. Nomad NVIDIA device plugin is installed and enabled

## Running GPU Jobs

To run a job that requires GPU access, include a device stanza in your job specification:

```hcl
resources {
  cpu    = 500
  memory = 256
  
  device "nvidia/gpu" {
    count = 1
    
    # Optional: Request specific GPU capabilities
    constraint {
      attribute = "${device.attr.memory}"
      operator  = ">"
      value     = "4096"  # 4GB VRAM
    }
  }
}
```

### Example GPU Job

See the `example_gpu_job.nomad` file for a complete example of a GPU job.

To run the example:

```bash
nomad job run example_gpu_job.nomad
```

## Running Non-GPU Jobs

Non-GPU jobs work normally without any special configuration. See `example_non_gpu_job.nomad` for an example.

## Checking GPU Status

To check the status of GPUs in your Nomad cluster:

```bash
# Check if GPUs are detected by Nomad
nomad node status -verbose

# Check GPU allocation
nomad device status
```

## Troubleshooting

### GPU Not Detected

If Nomad doesn't detect your GPU:

1. Verify the GPU is physically installed and recognized by the OS:
   ```bash
   lspci | grep -i nvidia
   ```

2. Check if NVIDIA drivers are installed:
   ```bash
   nvidia-smi
   ```

3. Verify the NVIDIA Container Toolkit is working:
   ```bash
   docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
   ```

4. Check Nomad logs for plugin errors:
   ```bash
   journalctl -u nomad
   ```

### GPU Jobs Failing

If GPU jobs are failing:

1. Ensure the job is being scheduled on a node with GPU capability
2. Check that the Docker image is compatible with the installed NVIDIA drivers
3. Verify that the NVIDIA runtime is configured correctly in Docker

## Resource Allocation Best Practices

1. **GPU Memory**: Consider the memory requirements of your workload when allocating GPUs
2. **CPU Allocation**: GPU workloads often need significant CPU resources as well
3. **Shared GPUs**: For better utilization, consider using NVIDIA MPS for shared GPU access

## Further Reading

- [Nomad GPU Plugin Documentation](https://www.nomadproject.io/docs/devices/nvidia)
- [NVIDIA Container Toolkit Documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/overview.html)
- [Docker GPU Documentation](https://docs.docker.com/config/containers/resource_constraints/#gpu)