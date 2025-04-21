# 🚀 Ansible role for Portainer Agent

This repository contains a custom [Ansible](https://docs.ansible.com/) provider for install [Portainer Agent](https://www.portainer.io/). It includes a full development environment using [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) for easy local development and testing.

---

## 🐳 Dev Container Support

This repository includes a `.devcontainer` setup based on Docker-in-Docker (DinD), enabling you to develop and test the provider in an isolated environment without requiring Docker access on the host system.

### ✅ Prerequisites

- [Docker](https://www.docker.com/get-started) installed on your host machine
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

> **Note:** The setup uses Docker-in-Docker with `--privileged` mode. You **don't need to mount your host Docker socket**.

---

### 🚀 Getting Started Locally

1. Clone this repository
2. Open the repo in **VS Code**
3. If prompted, install the **Dev Containers** extension
4. Click **"Reopen in Container"** when prompted  
   Or use the Command Palette: `Dev Containers: Reopen in Container`
5. The container will build and automatically run:

```bash
make install
```
6. After changes in role you can lint and test by run:
```bash
make lint
make test
```

### 🚀 Getting Started in GitHub

1. Click on **<> Code** -> **Codespace** -> **Create codespace on main**
2. GitHub open the repo in online **VS Code** loaded repository and run:

```bash
make install
```
3. After changes in role you can test by run:
```bash
make lint
make test
```
