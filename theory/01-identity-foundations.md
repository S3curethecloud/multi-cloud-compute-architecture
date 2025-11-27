# 🧩 SecureTheCloud Academy — Volume 1  
## **Chapter 01 — Identity Foundations**  
Zero Trust Identity Layer

---

<div align="center">

![Identity Banner](../diagrams/identity-banner.png)

📺 **Watch the Identity Foundations Lesson:**  
https://www.youtube.com/@SecureTheCloud-dev

</div>

---

# 🌍 Overview  
Identity is the core control plane of all Zero Trust architectures.  
Before traffic is allowed, before permissions are granted, before data is accessed — **identity must be verified, authenticated, and authorized.**

In SecureTheCloud Volume 1, we unify:

- **Microsoft Entra ID (Azure AD)** → as the Enterprise Identity Provider (IdP)  
- **AWS IAM Identity Center** → as the Cloud Service Provider (SP)

This chapter lays the foundation for federation, SCIM provisioning, RBAC design, and Zero Trust identity enforcement.

---

# 🔐 What Is Identity in the Cloud?

Identity is the **new security perimeter**.  
It is:

- A policy decision engine  
- A risk evaluation system  
- A trust authority  
- A Zero Trust enforcement point  

Identity = Authentication + Authorization + Continuous Verification.

Modern identity platforms evaluate:

- User risk  
- Device compliance  
- Location/travel anomalies  
- Token freshness  
- Conditional Access policies  

---

# 🧠 **Modern Identity = Token-Based Access**

Passwords are dying. Tokens run Zero Trust.

The main token types:

- **ID Token** → Who you are  
- **Access Token** → What you can access  
- **Refresh Token** → Extend your session  

Tokens carry:

- Claims  
- Groups  
- Permissions  
- Evaluated Conditional Access results  
- MFA state  

---

# 🏛️ **Identity Provider (IdP)**  
Responsible for:

- Credential validation  
- MFA  
- Policy enforcement  
- Token issuance  
- Risk analysis  
- Session management  

For SecureTheCloud:

### ⭐ **Microsoft Entra ID = IdP**

---

# 🏢 **Service Provider (SP)**  
Consumes tokens issued by the IdP.

For SecureTheCloud:

### ⭐ **AWS IAM Identity Center = SP**

---

# 🔄 High-Level Identity Flow

1. User attempts to access AWS console  
2. AWS redirects to Microsoft Entra  
3. Entra enforces MFA + Conditional Access  
4. User authenticated → Token issued  
5. AWS maps user to Permission Sets  
6. Temporary AWS console session is granted  

---

# 🌐 Identity Integration Layers

### **1. Federation — Authentication**  
SAML / OIDC → trusting authentication from the IdP.

### **2. Provisioning — Identity Sync**  
SCIM → syncing users & groups from Entra ID to AWS.

### **3. Authorization — Permissions**  
Permission Sets → controlling what identities can do.

All three are implemented in this volume.

---

# 🚀 Next Chapter  
➡️ **Chapter 02 — AWS IAM Identity Center Overview**  
[Next → 02-aws-identity-center-overview.md](02-aws-identity-center-overview.md)

---

# 🔙 Back to README  
https://github.com/S3curethecloud/multi-cloud-identity-aws-entra

---

# 🧭 **SecureTheCloud Footer**

<div align="center">

![Logo](../diagrams/securethecloud-logo.png)

**© 2025 SecureTheCloud.dev — All Rights Reserved**  
Zero Trust • Multi-Cloud • Enterprise Architecture  

[Terms](https://securethecloud.dev/terms) •  
[Privacy](https://securethecloud.dev/privacy) •  
[Status](https://securethecloud.dev/status) •  
[Community](https://t.me/SecureTheCloud) •  
[Docs](https://securethecloud.dev/docs)

</div>
