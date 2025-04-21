# Nomad Role

This Ansible role installs and configures HashiCorp Nomad with support for both GPU and non-GPU workloads.

## Features

- Automatic installation of Nomad server and client nodes
- Automatic detection of NVIDIA GPUs on client nodes
- Installation of NVIDIA drivers and container runtime on GPU-equipped nodes
- Configuration of Nomad for optimal GPU job scheduling
- Example job specifications for both GPU and non-GPU workloads
- Comprehensive validation of the setup

## Requirements

- Ubuntu/Debian or RHEL/CentOS Linux
- Docker installed (for container workloads)
- Ansible 2.9 or higher

## Role Variables

### General Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `nomad_user` | User to run Nomad as | `root` |
| `nomad_group` | Group to run Nomad as | `root` |
| `nomad_data_dir` | Directory for Nomad data | `/opt/nomad` |
| `nomad_alloc_dir` | Directory for Nomad allocations | `/opt/alloc_mounts` |
| `nomad_plugin_dir` | Directory for Nomad plugins | `/opt/nomad/plugins` |
| `nomad_is_server` | Whether this node is a Nomad server | `false` |
| `nomad_is_client` | Whether this node is a Nomad client | `false` |

### GPU Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `nvidia_driver_version` | NVIDIA driver version to install | `525` |
| `nomad_nvidia_plugin_version` | Nomad NVIDIA plugin version | `0.12.1` |
| `has_nvidia_gpu` | Whether this node has an NVIDIA GPU | Auto-detected |

## Example Playbook

```yaml
- name: Setup Nomad Server
  hosts: nomad_server
  become: yes
  roles:
    - role: nomad
      nomad_is_server: true
      nomad_config_template: nomad_server.hcl.j2

- name: Setup Nomad Client
  hosts: nomad_client
  become: yes
  roles:
    - role: nomad
      nomad_is_client: true
      nomad_config_template: nomad_client.hcl.j2
```

## GPU Compatibility

This role automatically detects NVIDIA GPUs on client nodes and configures them for use with Nomad. The detection process:

1. Checks if NVIDIA GPUs are present using `lspci`
2. Installs appropriate NVIDIA drivers
3. Installs NVIDIA Container Toolkit
4. Configures Docker to use the NVIDIA runtime
5. Installs and configures the Nomad NVIDIA device plugin

For detailed information on using GPUs with Nomad, see the [GPU Compatibility Guide](files/GPU_COMPATIBILITY.md).

## Example Jobs

Example job specifications are provided in the `files` directory:

- `example_gpu_job.nomad`: Example job that uses an NVIDIA GPU
- `example_non_gpu_job.nomad`: Example job that doesn't require a GPU

These files are copied to `/opt/nomad/examples/` on client nodes during setup.

## License

MIT

## Author Information

HashiCorp Stack Automation Team
