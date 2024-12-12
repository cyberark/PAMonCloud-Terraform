variable "rules" {
  description = "Map of  security group rules for each component (define as 'name' = ['from port', 'to port', 'protocol', 'description', 'source_security_group_id', 'cidr'])"
  type        = map(map(list(any)))
  default = {
    Vault = {
      VaultSGIngress1  = ["ingress", 1858, 1858, "tcp", "Vault to Main Vault connection", "Vault Main Subnet"]
      VaultSGIngress2  = ["ingress", 1858, 1858, "tcp", "Vault to Vault DR connection", "Vault DR Subnet"]
      VaultSGIngress3  = ["ingress", 1858, 1858, "tcp", "Vault to Main PVWA connection", "PVWA Main Subnet"]
      VaultSGIngress4  = ["ingress", 1858, 1858, "tcp", "Vault to Secondary PVWA connection", "PVWA Secondary Subnet"]
      VaultSGIngress5  = ["ingress", 1858, 1858, "tcp", "Vault to Main CPM connection", "CPM Main Subnet"]
      VaultSGIngress6  = ["ingress", 1858, 1858, "tcp", "Vault to CPM DR connection", "CPM DR Subnet"]
      VaultSGIngress7  = ["ingress", 1858, 1858, "tcp", "Vault to Main PTA connection", "PTA Main Subnet"]
      VaultSGIngress8  = ["ingress", 1858, 1858, "tcp", "Vault to PTA DR connection", "PTA DR Subnet"]
      VaultSGIngress9  = ["ingress", 1858, 1858, "tcp", "Vault to Main PSM connection", "PSM Main Subnet"]
      VaultSGIngress10 = ["ingress", 1858, 1858, "tcp", "Vault to Secondary PSM connection", "PSM Secondary Subnet"]
      VaultSGIngress11 = ["ingress", 1858, 1858, "tcp", "Vault to Main PSMP connection", "PSMP Main Subnet"]
      VaultSGIngress12 = ["ingress", 1858, 1858, "tcp", "Vault to Secondary PSMP connection", "PSMP Secondary Subnet"]
      VaultSGIngress14 = ["ingress", -1, -1, "icmp", "Vault to Vault DR ICMP connection", "Vault DR Subnet"]
      VaultSGIngress15 = ["ingress", 5671, 5671, "tcp", "Vault to Main PVWA connection", "PVWA Main Subnet"]
      VaultSGIngress16 = ["ingress", 5671, 5671, "tcp", "Vault to Secondary PVWA connection", "PVWA Secondary Subnet"]
      VaultSGIngress17 = ["ingress", 5671, 5671, "tcp", "Vault to Main Vault connection", "Vault Main Subnet"]
      VaultSGIngress18 = ["ingress", 5671, 5671, "tcp", "Vault to Vault DR connection", "Vault DR Subnet"]
      VaultSGIngress19 = ["ingress", -1, -1, "icmp", "Vault ICMP connection", "Vault Main Subnet"]

      VaultSGEgress1 = ["egress", 1858, 1858, "tcp", "Vault to Vault DR connection", "Vault DR Subnet"]
      VaultSGEgress2 = ["egress", -1, -1, "icmp", "Vault to Vault DR ICMP connection", "Vault DR Subnet"]
      VaultSGEgress3 = ["egress", 514, 514, "udp", "Vault to Main PTA syslog messages", "PTA Main Subnet"]
      VaultSGEgress4 = ["egress", 514, 514, "udp", "Vault to PTA DR syslog messages", "PTA DR Subnet"]
      VaultSGEgress5 = ["egress", 5671, 5671, "tcp", "Vault to Vault connection", "Vault Main Subnet"]
      VaultSGEgress6 = ["egress", 5671, 5671, "tcp", "Vault to Vault connection", "Vault DR Subnet"]
      VaultSGEgress7 = ["egress", 443, 443, "tcp", "Vault to AWS resources connection", "0.0.0.0/0"]
      VaultSGEgress8 = ["egress", 1858, 1858, "tcp", "Vault to Vault connection", "Vault Main Subnet"]
    }

    CPM = {
      CPMSGIngress1 = ["ingress", 3389, 3389, "tcp", "Access from Administrative CIDR", "AdministrativeAccessCIDR"]

      CPMSGEgress1 = ["egress", 1858, 1858, "tcp", "CPM to Vault Main Subnet", "Vault Main Subnet"]
      CPMSGEgress2 = ["egress", 1858, 1858, "tcp", "CPM to Vault DR Subnet", "Vault DR Subnet"]

      CPMSGEgress3 = ["egress", 443, 443, "tcp", "CPM to AWS resources connection", "0.0.0.0/0"]
    }

    PSM = {
      PSMSGIngress1 = ["ingress", 3389, 3389, "tcp", "Access from Administrative CIDR", "AdministrativeAccessCIDR"]
      PSMSGIngress2 = ["ingress", 3389, 3389, "tcp", "Access from User Access CIDR", "UsersAccessCIDR"]

      PSMSGEgress1 = ["egress", 3389, 3389, "tcp", "PSM to 0.0.0.0/0", "0.0.0.0/0"]
      PSMSGEgress2 = ["egress", 443, 443, "tcp", "PSM to 0.0.0.0/0", "0.0.0.0/0"]
      PSMSGEgress3 = ["egress", 1858, 1858, "tcp", "PSM to Vault Main Subnet", "Vault Main Subnet"]
      PSMSGEgress4 = ["egress", 1858, 1858, "tcp", "PSM to Vault DR Subnet", "Vault DR Subnet"]
    }

    PSMP = {
      PSMPSGIngress1 = ["ingress", 22, 22, "tcp", "Access from Administrative CIDR", "AdministrativeAccessCIDR"]
      PSMPSGIngress2 = ["ingress", 22, 22, "tcp", "Access from User Access CIDR", "UsersAccessCIDR"]

      PSMPSGEgress1 = ["egress", 22, 22, "tcp", "PSMP to 0.0.0.0/0", "0.0.0.0/0"]
      PSMPSGEgress2 = ["egress", 443, 443, "tcp", "PSMP to 0.0.0.0/0", "0.0.0.0/0"]
      PSMPSGEgress3 = ["egress", 1858, 1858, "tcp", "PSMP to Vault Main Subnet", "Vault Main Subnet"]
      PSMPSGEgress4 = ["egress", 1858, 1858, "tcp", "PSMP to Vault DR Subnet", "Vault DR Subnet"]
    }

    PVWA = {
      PVWASGIngress1  = ["ingress", 443, 443, "tcp", "Access from User Access CIDR", "UsersAccessCIDR"]
      PVWASGIngress2  = ["ingress", 3389, 3389, "tcp", "Access from Administrative CIDR", "AdministrativeAccessCIDR"]
      PVWASGIngress3  = ["ingress", 443, 443, "tcp", "Access from CPM Main Subnet", "CPM Main Subnet"]
      PVWASGIngress4  = ["ingress", 443, 443, "tcp", "Access from CPM DR Subnet", "CPM DR Subnet"]
      PVWASGIngress5  = ["ingress", 443, 443, "tcp", "Access from PSM Main Subnet", "PSM Main Subnet"]
      PVWASGIngress6  = ["ingress", 443, 443, "tcp", "Access from PSM Secondary Subnet", "PSM Secondary Subnet"]
      PVWASGIngress7  = ["ingress", 443, 443, "tcp", "Access from PSMP Main Subnet", "PSMP Main Subnet"]
      PVWASGIngress8  = ["ingress", 443, 443, "tcp", "Access from PSMP Secondary Subnet", "PSMP Secondary Subnet"]
      PVWASGIngress9  = ["ingress", 443, 443, "tcp", "Access from PTA Main Subnet", "PTA Main Subnet"]
      PVWASGIngress10 = ["ingress", 443, 443, "tcp", "Access from PTA DR Subnet", "PTA DR Subnet"]

      PVWASGEgress1 = ["egress", 1858, 1858, "tcp", "PVWA to Vault Main Subnet", "Vault Main Subnet"]
      PVWASGEgress2 = ["egress", 1858, 1858, "tcp", "PVWA to Vault DR Subnet", "Vault DR Subnet"]
      PVWASGEgress3 = ["egress", 443, 443, "tcp", "PVWA to 0.0.0.0/0", "0.0.0.0/0"]
      PVWASGEgress4 = ["egress", 5671, 5671, "tcp", "PVWA to Vault Main Subnet", "Vault Main Subnet"]
      PVWASGEgress5 = ["egress", 5671, 5671, "tcp", "PVWA to Vault DR Subnet", "Vault DR Subnet"]
      PVWASGEgress6 = ["egress", 8443, 8443, "tcp", "PVWA to Main PTA", "PTA Main Subnet"]
      PVWASGEgress7 = ["egress", 8443, 8443, "tcp", "PVWA to PTA DR", "PTA DR Subnet"]
    }

    PTA = {
      PTASGIngress1  = ["ingress", 443, 443, "tcp", "Access from Administrative CIDR - Allow incoming HTTPS communication for the PTA web and REST APIs using TLS1.2 with strong ciphers", "AdministrativeAccessCIDR"]
      PTASGIngress2  = ["ingress", 80, 80, "tcp", "Access from Administrative CIDR - Allow incoming HTTP communication for the PTA web. This is redirected to HTTPS by the Tomcat Web Server", "AdministrativeAccessCIDR"]
      PTASGIngress3  = ["ingress", 8080, 8080, "tcp", "Access from Administrative CIDR - Allow incoming HTTP communication for the PTA web. This is redirected to HTTPS by the Tomcat Web Server", "AdministrativeAccessCIDR"]
      PTASGIngress4  = ["ingress", 8443, 8443, "tcp", "Access from Administrative CIDR - Allow incoming HTTPS communication for the PTA web and REST APIs using TLS1.2 with strong ciphers", "AdministrativeAccessCIDR"]
      PTASGIngress5  = ["ingress", 67, 68, "udp", "Allow incoming data from the DHCP server", "0.0.0.0/0"]
      PTASGIngress6  = ["ingress", 6514, 6514, "tcp", "Allow incoming secure syslog messages for the PTA Windows Agent connection", "0.0.0.0/0"]
      PTASGIngress7  = ["ingress", 7514, 7514, "tcp", "Allow incoming secure syslog messages for the PTA Windows Agent connection", "0.0.0.0/0"]
      PTASGIngress8  = ["ingress", 22, 22, "tcp", "Allow remote access to the machine (SSH), for both secure telnet and SFTP", "AdministrativeAccessCIDR"]
      PTASGIngress9  = ["ingress", 11514, 11514, "tcp", "Allow incoming syslog messages", "0.0.0.0/0"]
      PTASGIngress10 = ["ingress", 11514, 11514, "udp", "Allow incoming syslog messages", "0.0.0.0/0"]
      PTASGIngress11 = ["ingress", 27017, 27017, "tcp", "Allow incoming replication to the Secondary PTA Server from the Primary PTA Server in a disaster recovery environment", "PTA Main Subnet"]
      PTASGIngress12 = ["ingress", 27017, 27017, "tcp", "Allow incoming replication to the Secondary PTA Server from the Primary PTA Server in a disaster recovery environment", "PTA DR Subnet"]
      PTASGIngress13 = ["ingress", 22, 22, "tcp", "Allow remote access to the machine (SSH), for both secure telnet and SFTP", "PTA Main Subnet"]
      PTASGIngress14 = ["ingress", 22, 22, "tcp", "Allow remote access to the machine (SSH), for both secure telnet and SFTP", "PTA DR Subnet"]
      PTASGIngress15 = ["ingress", 443, 443, "tcp", "Access from Administrative CIDR - Allow incoming HTTPS communication for the PTA web and REST APIs using TLS1.2 with strong ciphers", "PVWA Main Subnet"]
      PTASGIngress16 = ["ingress", 443, 443, "tcp", "Access from Administrative CIDR - Allow incoming HTTPS communication for the PTA web and REST APIs using TLS1.2 with strong ciphers", "PVWA Secondary Subnet"]
      PTASGIngress17 = ["ingress", 514, 514, "udp", "Allow incoming syslog messages", "Vault Main Subnet"]
      PTASGIngress18 = ["ingress", 514, 514, "udp", "Allow incoming syslog messages", "Vault DR Subnet"]
      PTASGIngress19 = ["ingress", 80, 80, "tcp", "Access from Main PVWA CIDR - Allow incoming HTTP communication for the PTA web. This is redirected to HTTPS by the Tomcat Web Server", "PVWA Main Subnet"]
      PTASGIngress20 = ["ingress", 80, 80, "tcp", "Access from PVWA Secondary CIDR - Allow incoming HTTP communication for the PTA web. This is redirected to HTTPS by the Tomcat Web Server", "PVWA Secondary Subnet"]
      PTASGIngress21 = ["ingress", 8080, 8080, "tcp", "Access from Main PVWA CIDR - Allow incoming HTTP communication for the PTA web. This is redirected to HTTPS by the Tomcat Web Server", "PVWA Main Subnet"]
      PTASGIngress22 = ["ingress", 8080, 8080, "tcp", "Access from Secondary PVWA CIDR - Allow incoming HTTP communication for the PTA web. This is redirected to HTTPS by the Tomcat Web Server", "PVWA Secondary Subnet"]
      PTASGIngress23 = ["ingress", 8443, 8443, "tcp", "Access from Main PVWA CIDR - Allow incoming HTTPS communication for the PTA web and REST APIs using TLS1.2 with strong ciphers", "PVWA Main Subnet"]
      PTASGIngress24 = ["ingress", 8443, 8443, "tcp", "Access from PVWA Secondary CIDR - Allow incoming HTTPS communication for the PTA web and REST APIs using TLS1.2 with strong ciphers", "PVWA Secondary Subnet"]
      PTASGIngress25 = ["ingress", 514, 514, "tcp", "Allow incoming syslog messages", "Vault Main Subnet"]
      PTASGIngress26 = ["ingress", 514, 514, "tcp", "Allow incoming syslog messages", "Vault DR Subnet"]

      PTASGEgress1  = ["egress", 443, 443, "tcp", "PTA to AWS Resources connection", "0.0.0.0/0"]
      PTASGEgress2  = ["egress", 514, 514, "tcp", "Allow sending syslog messages in port 514", "0.0.0.0/0"]
      PTASGEgress3  = ["egress", 514, 514, "udp", "Allow sending syslog messages in port 514", "0.0.0.0/0"]
      PTASGEgress4  = ["egress", 53, 53, "udp", "Allow outgoing DNS requests", "0.0.0.0/0"]
      PTASGEgress5  = ["egress", 123, 123, "udp", "Allow outgoing NTP requests", "0.0.0.0/0"]
      PTASGEgress6  = ["egress", 25, 25, "tcp", "Allow sending SMTP (email) messages for specific IP address", "0.0.0.0/0"]
      PTASGEgress7  = ["egress", 587, 587, "tcp", "Allow sending SMTP (email) messages for specific IP address", "0.0.0.0/0"]
      PTASGEgress8  = ["egress", 389, 389, "tcp", "LDAP for specific IP address", "0.0.0.0/0"]
      PTASGEgress9  = ["egress", 636, 636, "tcp", "LDAP for specific IP address", "0.0.0.0/0"]
      PTASGEgress10 = ["egress", 3268, 3269, "tcp", "LDAP for specific IP address", "0.0.0.0/0"]
      PTASGEgress11 = ["egress", 1858, 1858, "tcp", "Allow outgoing connection to the CyberArk Vault for specific IP address", "Vault Main Subnet"]
      PTASGEgress13 = ["egress", 1858, 1858, "tcp", "Allow outgoing connection to the CyberArk Vault for specific IP address", "Vault DR Subnet"]
      PTASGEgress14 = ["egress", 1858, 1858, "udp", "Allow outgoing connection to the CyberArk Vault for specific IP address", "Vault DR Subnet"]
      PTASGEgress12 = ["egress", 1858, 1858, "udp", "Allow outgoing connection to the CyberArk Vault for specific IP address", "Vault Main Subnet"]
      PTASGEgress15 = ["egress", 80, 80, "tcp", "Allow an outgoing HTTP connection to CyberArk PVWA for a specific IP address", "PVWA Main Subnet"]
      PTASGEgress16 = ["egress", 80, 80, "tcp", "Allow an outgoing HTTP connection to CyberArk PVWA for a specific IP address", "PVWA Secondary Subnet"]
      PTASGEgress17 = ["egress", 27017, 27017, "tcp", "Allow outgoing replication to the Secondary PTA Server from the Primary PTA Server in a disaster recovery environment", "PTA Main Subnet"]
      PTASGEgress18 = ["egress", 27017, 27017, "tcp", "Allow outgoing replication to the Secondary PTA Server from the Primary PTA Server in a disaster recovery environment", "PTA DR Subnet"]
      PTASGEgress19 = ["egress", 22, 22, "tcp", "Allow outgoing connection to the PTA Network Sensor for a specific IP address. Enable outgoing SSH connection in a disaster recovery environment", "PTA Main Subnet"]
      PTASGEgress20 = ["egress", 22, 22, "tcp", "Allow outgoing connection to the PTA Network Sensor for a specific IP address. Enable outgoing SSH connection in a disaster recovery environment", "PTA DR Subnet"]
    }
  }
}