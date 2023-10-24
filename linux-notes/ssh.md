# SSH

```shell script
# In the examples below 10.0.0.1 is a firewall that is forwarding port 22 to a host in the network.

# Setup port forwarding to 192.168.1.112 through 10.0.0.1:
ssh -L 30000:192.168.1.112:22 root@10.0.0.1

# Connect to 192.168.1.112 using the above port forwarding:
ssh -p 30000 gp@localhost

# Setup port forwarding to 192.168.1.112 through 10.0.0.1, and connect to 192.168.1.112:
ssh -L 30000:192.168.1.112:22 gp@10.0.0.1 -t 'ssh gp@192.168.1.112'
```

```shell script
# Open a reverse tunnel, prompt for password, don't execute a remote command:
ssh -N -R 30000:localhost:22 gp@10.0.0.1
# The $RANDOM variable can be used for keeping tunnels open.

# Setup port forwarding to the remote host through a tunnel server, and connect to the remote host.
# This saves the HostKeyAlias as something other than 127.0.0.1 which would cause conflicts
# if reverse tunnels from multiple hosts were being opened simultaneously.
ssh -p 5222 gp@tunnel.server.com -L 30000:127.0.0.1:30000 -t 'ssh -p 30000 -o HostKeyAlias=prt30000 -l gp 127.0.0.1'

# Connect to the reverse tunnel from 10.0.0.1:
ssh -p 30000 gp@localhost
```

```shell script
# Setup passwordless ssh, scp, sftp connections.
# If a password is entered, the same password will be required
# when logging in the first time (each first time).

# Create a public/private key pair:
ssh-keygen

# Create a public key from an existing private key:
ssh-keygen -y -f id_rsa > id_rsa.pub

# Copy and append the id_rsa.pub to .ssh/authorized_keys on the remote machine.
chmod 600 .ssh/authorized_keys  # run on the remote machine
# The local user might need to logout and login again.

# Additional step when connecting from one remote machine
# to another when the key was created using a password:
exec /usr/bin/ssh-agent $SHELL
ssh-add

# Enforce the key-based authentication:
# Either of following depending on the system.
# /etc/ssh/ssh_config --> PasswordAuthentication no
# /etc/ssh/sshd_config --> PasswordAuthentication no
```

```shell script
# Disable pseudo tty allocation, commands can still be executed:
# Using -N or -T seems to prevent the user’s last login from being updated.
ssh -T gp@192.168.0.111
```

```shell script
# Transfer a file when scp or rsync are not available:
ssh gp@server1 'cat file1.txt' > /var/tmp/file1.txt
```

```shell script
# Dealing with ssh login problems:
# -o ConnectTimeout=10  # Ends connection attempt after 10 seconds if not established
# -o BatchMode=yes      # Closes connection if server prompts for a passphrase/password
ssh server1 'uname'     # Closes connection if server prompts to change password
```
