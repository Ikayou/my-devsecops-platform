---

#  Cloud-Native DevSecOps Platform
**Automatisierte Infrastructure, Security & Observability**

##  Projektziel
Dieses Projekt bildet eine produktionsnahe DevSecOps-Umgebung ab. Der Fokus liegt auf einem **vollautomatisierten Lifecycle**, der Sicherheit und Betrieb effizient verbindet:
*   **GitOps**: Konsistente Infrastruktur durch Argo CD als Single Source of Truth.
*   **Shift-Left Security**: Frühzeitige Identifikation von Schwachstellen im Entwicklungsprozess.
*   **Automated Ops**: Ersatz von Routineaufgaben durch intelligente Workflows.

---

##  Architektur & Technologie-Stack

Die Plattform nutzt den **App-of-Apps-Ansatz**. Über die zentrale **`bootstrap/root-app.yaml`** synchronisiert Argo CD den gesamten Cluster-Zustand automatisch mit dem GitHub-Repository. Jede Änderung im Git führt zu einem sofortigen Update im Cluster.

### Core-Komponenten:
*   **Deployment**: Argo CD, Helm, Kustomize.
*   **Automation**: Argo Workflows (CronWorkflows & Templates).
*   **Security**: Keycloak, Bitnami Sealed Secrets, Falco, Trivy.
*   **Observability**: Prometheus, Grafana, Loki, Fluent-bit.

---

##  Security & Automation Features

### 1. Schwachstellen-Management mit Jira & Slack
Ich habe einen automatisierten Security-Scan via **Argo Workflows** implementiert:
*   **Trivy-Scanner**: Ein spezialisiertes Python-Image scannt Apps wie Keycloak oder Falco.
*   **Intelligentes Ticketing**: Ein Python-Skript prüft via JQL (Jira Query Language), ob für eine CVE bereits ein Ticket existiert. Falls nicht, wird automatisch ein **Jira-Ticket** erstellt und eine **Slack-Benachrichtigung** versendet.
*   **CI-Integration**: GitHub Actions prüft Code bei jedem Push. Werden kritische Probleme gefunden, erfolgt das Update der Version direkt im Code.

### 2. Keycloak Compliance Audit
Ein dedizierter Workflow überwacht die Sicherheit der Identitätslösung:
*   Die Keycloak API wird abgefragt, um User ohne **Multi-Faktor-Authentifizierung (MFA)** zu finden.
*   Diese Sicherheitslücken werden direkt an Slack gemeldet.

### 3. Monitoring & Self-Healing
*   **Endpoint-Check**: Ein Monitor überwacht SSL-Zertifikate (z.B. Keycloak-URL) auf ihre Gültigkeit und meldet Ablaufdaten an Slack.
*   **Pod-Health**: Ein Workflow erkennt abgestürzte Pods (`CrashLoopBackOff`) sofort und schlägt Alarm.
*   **Auto-Cleanup**: Ein täglicher CronWorkflow löscht beendete Workflows und optimiert so die Cluster-Ressourcen.

---

##  Design-Entscheidungen

### Kustomize-Struktur
Die Konfiguration ist modular aufgebaut:
*   **`base/`**: Enthält die Standard-Logik für CronWorkflows und Templates.
*   **`overlays/dev/`**: Ermöglicht umgebungsspezifische Anpassungen. Die Struktur ist so vorbereitet, dass ein **`production`-Overlay** jederzeit nahtlos integriert werden kann.

### Spezialisiertes Scanner-Image
Das `trivy-python-scanner` Image basiert auf `python:3.9-slim`. Die Wahl fiel auf dieses Image, um die **Angriffsfläche minimal** zu halten und gleichzeitig die nötigen Bibliotheken (`requests`) für die Kommunikation mit der Jira- und Slack-API bereitzustellen.

### Secret Management
Sicherheit steht an erster Stelle: Alle Passwörter und API-Tokens sind via **Sealed Secrets** asymmetrisch verschlüsselt und können gefahrlos im Git-Repository gespeichert werden.

---

##  Observability
Sicherheitsrelevante Ereignisse von **Falco** (Runtime Security) sowie Logs von **Fluent-bit** werden in **Loki** zentralisiert und in **Grafana** visualisiert. So entsteht eine lückenlose Überwachung der Infrastruktur.

##  Lernerfolge
*   **Orchestrierung**: Tiefes Verständnis für automatisierte Abläufe zwischen Scannern, Ticketing-Systemen und Messengern.
*   **GitOps-Expertise**: Beherrschung des kompletten Lifecycles von der Code-Änderung bis zum automatisierten Deployment.
*   **Proaktive Sicherheit**: Implementierung von Mechanismen, die Probleme lösen, bevor sie kritisch werden.

---