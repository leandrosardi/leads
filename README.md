# Leads

**Leads** is an extension of MySaaS to offer B2B databases.

## 1. Getting Started

Follow the steps below to install **Leads** as an extension in your **MySaaS** project 

We are assuming that you have installed your **MySaaS** in your computer, and it is working.
If you have not **MySaaS** working on your computer, follow [this tutorial](https://github.com/leandrosardi/mysaas/blob/main/docu/12.extensibility.md).

If you don't know how do **MySaaS** extensions work, refer to [this article]().

**Step 1:** Access the extensions folder of your **MySaaS** project.

```bash
cd ~/code/mysaas/extensions
```

**Step 2:** Clone the **Leads** project there.

```bash
git clone https://github.com/leandrosardi/leads/
```

**Step 3:** Add the extension in your configuration file

```ruby
# add required extensions
BlackStack::Extensions.append :leads
```

Restart the **MySaaS** webserver in order to get working the new extension.

## 2. Disclaimers

This project is still under construction.

The logo has been taken from [here](https://www.shareicon.net/shot-shooting-target-circular-target-targeting-target-interface-duck-700809).

