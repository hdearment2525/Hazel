---
title: Password Recovery
---

---

![Screenshot](./images/lockout_gui.png)

---
Our user is locked out of their account after 5 failed login attempts.

I have two options:
- Use Powershell
- Use AD Users & Groups

Using Powershell:
---

![Screenshot](./images/ps_unlock.png)

- Searching for all accounts that are locked out.
- Unlocking account based on SamAccountName
- Checking to see if the account is still locked out, which it isn't

Using ADUC:
---
![Screenshot](./images/app_unlock.png)

- Open Active Directory Users and Computers
- Navigate to the user who is locked out.
- Check Unlock Account and Apply

Potential Improvements:
---

- Automation
- Self Service like on Azure



