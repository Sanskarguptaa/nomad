job "gpu-example" {
  datacenters = ["dc1"]
  type = "batch"

  group "gpu-group" {
    task "gpu-task" {
      driver = "docker"

      config {
        image = "nvidia/cuda:11.6.2-base-ubuntu20.04"
        command = "nvidia-smi"
      }

      resources {
        cpu    = 500
        memory = 256
        
        device "nvidia/gpu" {
          count = 1
          
          # Optionally, you can request specific GPU models
          # constraint {
          #   attribute = "${device.attr.memory}"
          #   operator  = ">"
          #   value     = "4096"  # 4GB VRAM
          # }
        }
      }
    }
  }
}