# DEPRECATED - REPLACED WITH [FAIL2BAN Notifier](https://github.com/eyeskiller/fail2ban-notifier) !!!!!

# Fail2Ban Microsoft Teams Notifications

## Overview

A comprehensive solution for integrating Microsoft Teams notifications with Fail2Ban security monitoring, providing real-time alerts for security events with geographical information.

This integration enables Fail2Ban to send detailed notifications to Microsoft Teams channels when security events occur, including IP geolocation data for enhanced threat analysis.

---

## Prerequisites

### System Requirements

| Requirement | Version | Description |
|-------------|---------|-------------|
| **Fail2Ban** | 1.0.2+ | Core security monitoring service |
| **Root Access** | Required | Administrative privileges for configuration |
| **Network Access** | HTTPS | Outbound connectivity to Teams webhooks |
| **Shell Environment** | Bash | Standard utilities (curl, jq recommended) |

### Microsoft Teams Setup

:information_source: **Required Components:**
- Microsoft Teams workspace with administrative permissions
- Configured incoming webhook connector for target channel

---

## Installation

### :one: Repository Setup

```bash
# Clone the repository
git clone https://github.com/eyeskiller/fail2ban-ms-teams-notification.git
cd fail2ban-ms-teams-notification
```

### :two: File Deployment

```bash
# Copy action configuration file
sudo cp teams-geo.conf /etc/fail2ban/action.d/teams-geo.conf

# Copy notification script
sudo cp teams-notify.sh /etc/fail2ban/teams-notify.sh

# Set appropriate permissions
sudo chmod +x /etc/fail2ban/teams-notify.sh
```

### :three: Webhook Configuration

```bash
# Edit the notification script to add your Teams webhook URL
sudo nano /etc/fail2ban/teams-notify.sh

# Update the WEBHOOK variable:
WEBHOOK="https://your-organization.webhook.office.com/webhookb2/..."
```

### :four: Fail2Ban Jail Configuration

Add the `teams-geo` action to your desired jail configurations:

#### SSH Protection Configuration

```ini
[sshd]
enabled = true
port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
maxretry = 3
findtime = 600
bantime = 3600
action = %(action_)s
         teams-geo
```

#### Nginx HTTP Authentication Configuration

```ini
[nginx-http-auth]
enabled = true
port    = http,https
logpath = /var/log/nginx/error.log
maxretry = 3
findtime = 300
bantime = 1800
action = %(action_)s
         teams-geo
```

#### Custom Service Configuration

```ini
[custom-service]
enabled = true
port    = 8080
logpath = /var/log/custom/service.log
maxretry = 5
findtime = 900
bantime = 7200
action = %(action_)s
         teams-geo
```

---

## Service Management

### Configuration Validation

:white_check_mark: **Validation Steps:**

```bash
# Test Fail2Ban configuration syntax
sudo fail2ban-client --test

# Verify jail configurations
sudo fail2ban-client status
```

### Service Restart

:gear: **Restart Procedure:**

```bash
# Restart Fail2Ban service
sudo systemctl restart fail2ban

# Verify service status
sudo systemctl status fail2ban

# Check for any configuration errors
sudo journalctl -u fail2ban -f
```

### Testing the Integration

:test_tube: **Testing Commands:**

```bash
# Manually test the notification script
sudo /etc/fail2ban/teams-notify.sh "192.168.1.100" "test-jail" "manual-test"

# Monitor Fail2Ban logs for Teams notifications
sudo tail -f /var/log/fail2ban.log | grep teams-geo
```

---

## Troubleshooting

### :exclamation: Configuration File Not Found

| **Error** | `Found no accessible config files for 'action.d/teams-geo'` |
|-----------|-------------------------------------------------------------|

**Resolution Steps:**

```bash
# Verify file exists and has correct permissions
ls -la /etc/fail2ban/action.d/teams-geo.conf

# If missing, re-copy the file
sudo cp teams-geo.conf /etc/fail2ban/action.d/teams-geo.conf
sudo chmod 644 /etc/fail2ban/action.d/teams-geo.conf
```

### :exclamation: Script Permission Errors

| **Error** | Permission denied when executing notification script |
|-----------|-----------------------------------------------------|

**Resolution Steps:**

```bash
# Set correct permissions
sudo chmod 755 /etc/fail2ban/teams-notify.sh
sudo chown root:root /etc/fail2ban/teams-notify.sh
```

### :exclamation: Webhook Connection Issues

| **Error** | Teams notifications not appearing |
|-----------|-----------------------------------|

**Diagnostic Commands:**

```bash
# Test webhook manually
curl -X POST -H "Content-Type: application/json" \
  -d '{"text":"Test notification from Fail2Ban"}' \
  "YOUR_WEBHOOK_URL"

# Check network connectivity
sudo netstat -tlnp | grep fail2ban
```

### :exclamation: Service Restart Issues

| **Error** | Fail2Ban fails to start after configuration changes |
|-----------|-----------------------------------------------------|

**Recovery Procedure:**

```bash
# Check configuration syntax
sudo fail2ban-client --test

# Review system logs
sudo journalctl -u fail2ban --no-pager -l

# Restart with verbose logging
sudo fail2ban-client -v start
```

### Log Analysis Commands

:mag: **Monitoring and Analysis:**

```bash
# Monitor real-time Fail2Ban activity
sudo tail -f /var/log/fail2ban.log

# Search for Teams notification events
sudo grep "teams-geo" /var/log/fail2ban.log

# Check for webhook delivery status
sudo grep "webhook" /var/log/fail2ban.log
```

---

## Customization Options

### Notification Content Customization

:gear: **Editable Components:**

Edit `/etc/fail2ban/teams-notify.sh` to customize:
- Message formatting and structure
- Additional geolocation data sources
- Alert severity levels and categorization
- Custom styling, colors, and branding

### Action Parameters Configuration

:wrench: **Configurable Settings:**

Modify `/etc/fail2ban/action.d/teams-geo.conf` to adjust:
- Timeout values and retry mechanisms
- Custom variables and parameters
- Error handling and fallback options

---

## Security Considerations

:shield: **Security Best Practices:**

| Area | Recommendation |
|------|----------------|
| **Webhook Protection** | Store webhook URLs securely and rotate periodically |
| **Log Sensitivity** | Be aware that IP addresses and system information are transmitted |
| **Network Segmentation** | Consider firewall rules for outbound webhook traffic |
| **Access Control** | Limit access to configuration files and scripts |

---

## Maintenance and Support

### :calendar: Regular Maintenance Tasks

- Monitor webhook delivery success rates
- Review and update geolocation data sources  
- Test notification delivery monthly
- Update webhook URLs when Teams channels change

### :chart_with_upwards_trend: Performance Monitoring

```bash
# Check Fail2Ban performance impact
sudo fail2ban-client status
sudo systemctl show fail2ban --property=MemoryCurrent
```

---

## Additional Resources

:book: **Related Documentation:**
- [Fail2Ban Official Documentation](https://www.fail2ban.org/wiki/index.php/Main_Page)
- [Microsoft Teams Webhook Configuration](https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook)
- [Azure DevOps Security Best Practices](https://docs.microsoft.com/en-us/azure/devops/organizations/security/)

---

:information_source: **Note:** This integration can be applied to any Fail2Ban jail configuration by adding the `teams-geo` action to the desired services.
