<!-- .slide: data-auto-animate -->

<img class="r-stretch" src="images/k8s_logo_with_border.svg" alt="Kubernetes">

### Kubernetes Security Foo

Masterarbeit

<small>Sebastian Fleer</small>

---
<!-- .slide: data-auto-animate -->

## Quartäre Prävention

Definition: Die Verhinderung irrelevanter oder nutzloser Medizin

---
<!-- .slide: data-auto-animate -->

## Quartäre Prävention
- Vermeidung unnötiger Diagnostik
- Vermeidung unnötiger Therapien
- Entsprechende Aufklärung der Patienten
- Berücksichtigung von Patientenwünschen
- Vermehrte Aufnahme von Negativ-Empfehlungen z.B. in Leitlinien. <!-- .element: class="fragment" -->

---
<!-- .slide: data-background="images/kubernetes-cluster-architecture.svg" data-background-size="contain" -->

---
<!-- .slide: data-auto-animate -->

## Example Manifest

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: "admin-user"
type: kubernetes.io/service-account-token
```
