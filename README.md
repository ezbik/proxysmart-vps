# proxysmart-vps Ansible Role


Ansible playbook for preparing a VPS for port forwarding from a Proxysmart server.

Steps on the VPS

`apt install ansible`

- put public ssh key from the Proxysmart server in `ssh_pub_keys` list ( check vars.txt ) as an option of the role.
- or put public ssh key from the Proxysmart server in `./proxysmart.ssh.pubkeys/` , 1 server == 1 file == 1 pub.key
- then apply the role:

```
ansible-playbook ./proxysmart-vps.yml
```

