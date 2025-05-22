<p align="center">
  <a href="https://galaxy.ansible.com/ui/standalone/roles/portainer/portainer_agent">
    <img src="https://www.redhat.com/rhdc/managed-files/ansible-logo_white.svg" alt="Ansible" height="60">
  </a>
  &nbsp;&nbsp;&nbsp;
  <a href="https://portainer.io/">
    <img src="https://www.portainer.io/hubfs/portainer-logo-black.svg" alt="Portainer" height="60">
  </a>
</p>

<h3 align="center">Ansible Role for Portainer Agent</h3>
<p align="center">
</p>
<p align="center">
  <a href="https://github.com/grulicht/ansible-role-portainer-agent/graphs/contributors">
      <img alt="Contributors" src="https://img.shields.io/github/contributors/grulicht/ansible-role-portainer-agent">
  </a>
  <a href="https://github.com/grulicht/ansible-role-portainer-agent/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/grulicht/ansible-role-portainer-agent/e2e-test.yml?branch=main&label=CI e2e test" alt="GitHub Actions CI">
  </a>
  &nbsp;&nbsp;&nbsp;
  <a href="https://github.com/grulicht/ansible-role-portainer-agent/tags">
    <img src="https://img.shields.io/github/v/tag/grulicht/ansible-role-portainer-agent?label=latest%20tag" alt="Latest Tag">
  </a>
</p>
<p align="center">
    <a href="https://github.com/grulicht/ansible-role-portainer-agent/tree/main"><strong>Explore examples of playbooks »</strong></a>
</p>

# Ansible Role: portainer_agent

An Ansible role to install and deploy the [Portainer Agent](https://www.portainer.io/) in various container environments:

- Docker Standalone (Linux, WSL, Windows WCS)
- Docker Swarm (Linux, WSL, Windows WCS)
- Podman (Linux)
- Kubernetes (`LoadBalancer` / `NodePort`)

> 📖 [Official documentation reference](https://docs.portainer.io/admin/environments/add)

---

## 🚀 Features

- 🧠 Platform-aware configuration for volume mounts and socket paths (Linux, WSL, Windows).
- 🧩 Supports deployment via Docker Compose or Stack into configurable directory.
- 🔍 Pre-checks for required runtime (`docker`, `podman`, `kubectl`, etc.).
- 🔒 Robust variable validation with helpful error messages.
- 🧰 Flexible and configurable for CI/CD pipelines or manual playbooks.

---

## 📦 Requirements

- Ansible ≥ 2.11 (recommended: Ansible 2.13+)
- Docker or Podman or Kubernetes installed on target machine

---

## 📋 Role Variables

| Variable                                  | Description                                                                                       | Default                           | Notes                                           |
|-------------------------------------------|---------------------------------------------------------------------------------------------------|-----------------------------------|-------------------------------------------------|
| `portainer_agent_mode`                    | Deployment mode: `standalone`, `swarm`, `podman`, `k8s`                                           | `""`                              | **Required**                                    |
| `portainer_agent_os`                      | Platform type: `linux`, `wsl`, `wcs`, `podman`                                                    | `""`                              | **Required**                                    |
| `portainer_agent_docker_image_name`       | Docker image to use for the agent                                                                 | `docker.io/portainer/agent`       | Used in all modes                               |
| `portainer_agent_version`                 | Version of the Portainer Agent image to deploy                                                    | `"2.27.4"`                        | Used as tag and in Kubernetes YAML              |
| `portainer_agent_port`                    | Port to expose for agent communication                                                            | `9001`                            |                                                 |
| `portainer_agent_k8s_mode`                | Kubernetes service type: `lb` (LoadBalancer) or `nodeport`                                        | `""`                              | Required if mode is `k8s`                        |
| `portainer_agent_compose_dir`             | Base directory where Compose/Stack manifests are stored                                           | `/srv/data/portainer_agent`       | Used for `standalone`, `swarm`, `podman`        |
| `portainer_agent_container_name`          | Name of the Portainer Agent container or service                                                  | `portainer_agent`                 | Not used in `k8s`                               |
| `portainer_agent_network`                 | Docker Swarm network name used in Stack deployment                                                | `"portainer_agent_network"`       | Used only in `swarm` mode                       |
| `portainer_agent_docker_volume_path`      | Base directory for Docker bind-mounts                                                             | `/srv/data/docker`                | Used in `standalone`, `swarm`                   |
| `portainer_agent_podman_volume_path`      | Base directory for Podman bind-mounts                                                             | `/srv/data/podman`                | Used only in `podman`                           |
| `portainer_agent_docker_sock_path`        | Docker socket path (depends on OS/platform)                                                       | Derived from `portainer_agent_os` | Not used in `k8s`                               |
| `portainer_agent_docker_volumes_path`     | Docker volumes bind path (depends on OS/platform)                                                 | Derived from `portainer_agent_os` | Not used in `k8s`                               |
| `portainer_agent_root_mount_path`         | Host root bind mount (used by agent for metrics/volume access)                                    | Derived from `portainer_agent_os` | Not used in `k8s`                               |
| `portainer_agent_edge`                    | Enables Portainer Edge Agent mode                                                                 | `False`                           | Use `true` to enable edge functionality         |
| `portainer_agent_edge_id`                 | Edge ID assigned by Portainer for the agent                                                       | `""`                              | **Required if** `portainer_agent_edge` is `true`|
| `portainer_agent_edge_key`                | Edge Key assigned by Portainer for the agent                                                      | `""`                              | **Required if** `portainer_agent_edge` is `true`|
| `portainer_agent_edge_flag`               | Environment variable `EDGE`; must be `"1"`                                                        | `"1"`                             | Only relevant if Edge Agent is enabled          |
| `portainer_agent_edge_insecure_poll`      | Environment variable `EDGE_INSECURE_POLL`; must be `"1"` to allow insecure polling                | `"1"`                             | Only relevant if Edge Agent is enabled          |

---

## 🛠 Example Playbook

```yaml
- name: Deploy Portainer Agent
  hosts: all
  become: true
  roles:
    - role: portainer_agent
  vars:
    portainer_agent_mode: "standalone"
    portainer_agent_os: "linux"
```
---

### 💡 Missing a feature?

Is there a deployment scenario or Portainer platform you'd like to see supported in this role?

👉 [Open an issue](https://github.com/grulicht/ansible-role-portainer-agent/issues) and we’ll consider it for implementation — or even better, submit a [Pull Request](https://github.com/grulicht/ansible-role-portainer-agent/pulls) to contribute directly!

📘 See [CONTRIBUTING.md](./.github/CONTRIBUTING.md) for contribution guidelines.

---

## 💬 Community & Feedback

Have questions, ideas, or improvements to suggest?  
[Discussions](https://github.com/grulicht/ansible-role-portainer-agent/discussions)

Want to report issues, submit pull requests or browse the source code?  
Check out the [GitHub repository](https://github.com/grulicht/ansible-role-portainer-agent) for this role.

## 🧪 Localy development/testing
To test the ansible role locally, start the docker containers with different OS:
```sh
make test
```

---

## ✅ Daily End-to-End Testing

To ensure maximum reliability and functionality of this Ansible role, a **comprehensive CI pipeline** is run using [GitHub Actions](https://github.com/grulicht/ansible-role-portainer-agent/actions).

These tests verify the role in **real container environments** and simulate multiple deployment scenarios of the Portainer Agent:

- ✅ Docker Standalone  
- ✅ Docker Swarm  
- ✅ Podman  

The workflow is executed automatically:

- 📦 On every **pull request**
- 🔁 On every **push** to the `main` branch
- 🕖 **Daily at 07:00 UTC** via a scheduled cron job

---

## Roadmap
See the [open issues](https://github.com/grulicht/ansible-role-portainer-agent/issues) for a list of proposed features (and known issues).

See [CONTRIBUTING](./.github/CONTRIBUTING.md) for more information.

## License
This ansible role is 100% Open Source and is distributed under the MIT License. 

See [LICENSE](https://github.com/grulicht/ansible-role-portainer-agent/blob/main/LICENSE) for more information.

## Authors
Created by [Tomáš Grulich](https://github.com/grulicht)

## Acknowledgements
- [Ansible](https://docs.ansible.com/)
- [Portainer](https://portainer.io)
- [Docker](https://www.docker.com/)
- [Molecule](https://ansible.readthedocs.io/projects/molecule/)
