"""
See https://testinfra.readthedocs.io/en/latest/modules.html
for details.
"""

import re


def test_compose_directory_exists(host):
    d = host.file("/srv/data/portainer_agent")
    assert d.exists
    assert d.is_directory


def test_compose_file_exists(host):
    f = host.file("/srv/data/portainer_agent/docker-compose.yml")
    assert f.exists
    assert f.is_file


# def test_portainer_container_running(host):
#    result = host.run("docker ps --format '{{.Names}} {{.Image}} {{.Status}} {{.Ports}}'")
#    assert result.rc == 0
#
#    lines = result.stdout.strip().splitlines()
#
#    matched = False
#    for line in lines:
#        parts = line.split()
#        name = parts[0]
#        image = parts[1]
#        status = " ".join(parts[2:-1])
#        ports = parts[-1]
#
#        if re.search(r"portainer[-_]agent", name):
#            assert "portainer/agent:2.27.4" in image
#            assert "Up" in status
#            assert "9001" in ports
#            matched = True
#
#    assert matched, "No matching portainer_agent container found"
