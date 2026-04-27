# My DevSecOps Platform

## Übersicht
Dieses Projekt zeigt den Aufbau einer lokalen DevSecOps-Plattform auf Basis von Kubernetes.  
Ziel ist es, typische DevOps- und Security-Tools in einer Umgebung zu integrieren und praktisch anzuwenden.

---

## Architektur
Die Plattform basiert auf einer Kubernetes-Umgebung und integriert mehrere Tools aus den Bereichen Deployment, Monitoring und Security:

- **Kubernetes**: Lokales Cluster (Docker Desktop / Kind)
- **Argo CD**: GitOps-basiertes Deployment und Synchronisation
- **Helm**: Paketmanagement für Kubernetes-Applikationen
- **Prometheus & Grafana**: Monitoring, Metriken und Visualisierung
- **Falco & Trivy**: Runtime Security und Vulnerability Scanning
- **Keycloak**: Identity & Access Management (IAM)
- **Argo Workflows**: Automatisierung von operationalen Abläufen und Audits

---

## Funktionen

### GitOps Deployment
- Anwendungen werden über Argo CD automatisch aus Git-Repositories deployt.
- Änderungen im Repository werden direkt im Cluster synchronisiert.

### Monitoring & Observability
- Prometheus sammelt Metriken aus dem Cluster.
- Grafana visualisiert die Daten in Dashboards.
- Alerting-Regeln sind für kritische Zustände definiert.

### Security Integration
- Falco überwacht das Laufzeitverhalten von Containern.
- Trivy scannt Container-Images auf Schwachstellen.

### Automated Operations & Security Audits
Durch den Einsatz von Argo Workflows wurden automatisierte Prozesse für den sicheren Betrieb implementiert:

- **Automatisierter Keycloak MFA-Audit**:
  Regelmäßige Überprüfung der Benutzerkonten über die Keycloak-API. Identifiziert Konten ohne Multi-Faktor-Authentifizierung (MFA) und gibt die Ergebnisse in deutscher Sprache aus.
- **Cluster Health Guardian**:
  Ein automatisierter Prozess scannt alle Namespaces auf fehlerhafte Pod-Zustände (z. B. CrashLoopBackOff). Dies nutzt die native Kubernetes-API und eine dedizierte RBAC-Konfiguration.
- **Detailliertes Schwachstellen-Management (Trivy-Audit)**:
  Automatisierter Scan von Container-Images auf kritische Sicherheitslücken (HIGH/CRITICAL). Der Audit identifiziert betroffene Pakete, installierte Versionen sowie verfügbare Fix-Versionen zur sofortigen Risikobewertung.
- **Echtzeit-Benachrichtigung via Slack**:
  Kritische Audit-Ergebnisse, detaillierte Sicherheitsberichte und Systemfehler werden sofort über Slack-Webhooks gemeldet. Die Integration erfolgt sicher über Kubernetes Secrets.

---

## Automatisierung & Zeitsteuerung (CronWorkflows)
Die operationalen Tasks sind als CronWorkflows konfiguriert:
- **Keycloak Security Audit**: Täglich um 00:00 UTC.
- **Trivy Vulnerability Scan**: Täglich um 02:00 UTC (oder nach Bedarf).
- **Pod Health Check**: Stündlich zur Minute 0.

---

## Lernziele & Kenntnisse
Durch dieses Projekt wurden vertiefte Kenntnisse in folgenden Bereichen erworben:

- Kubernetes-Ressourcenmanagement und Troubleshooting.
- Implementierung von GitOps-Workflows mit Argo CD.
- Automatisierung von Betriebsabläufen (Day 2 Operations) mit Argo Workflows.
- Sicherheit durch API-basiertes Auditing und IAM-Prüfungen.
- Schwachstellen-Analyse und proaktives Patch-Management in Container-Umgebungen.
- Konfiguration von RBAC (ClusterRole, ServiceAccount) für automatisierte Tools.
- Integration von Drittanbieter-Tools (Slack) in automatisierte Pipelines.

---

## Setup (Kurzbeschreibung)

### Voraussetzungen
- Docker
- kubectl
- Helm
- Kubernetes Cluster

### Installation (Beispiel)
```bash
# Cluster erstellen
kind create cluster

# Argo CD installieren
kubectl create namespace argocd
kubectl apply -n argocd -f [https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml)

# Zugriff (Port Forward)
kubectl port-forward svc/argocd-server -n argocd 8080:443