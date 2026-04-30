# My DevSecOps Platform

## Übersicht
Dieses Projekt zeigt den Aufbau einer lokalen DevSecOps-Plattform auf Basis von Kubernetes.  
Ziel ist es, typische DevOps- und Security-Tools in einer Umgebung zu integrieren und praktisch anzuwenden.

---

## Architektur
Die Plattform basiert auf einer Kubernetes-Umgebung und integriert mehrere Tools aus den Bereichen Deployment, Monitoring und Security:

- **Kubernetes**: Lokales Cluster (Docker Desktop / Kind)
- **GitHub Actions**: CI-Pipeline für automatisiertes Security Scanning und Quality Gates
- **Argo CD**: GitOps-basiertes Deployment und Synchronisation
- **Kustomize**: Konfigurationsmanagement durch Base- und Overlay-Strukturen zur Trennung von Umgebungen
- **Sealed Secrets**: Asymmetrische Verschlüsselung von Secrets zur sicheren Speicherung im Git-Repository
- **Helm**: Paketmanagement für Kubernetes-Applikationen
- **Prometheus & Grafana**: Monitoring, Metriken und Visualisierung
- **Falco & Trivy**: Runtime Security und Vulnerability Scanning
- **Keycloak**: Identity & Access Management (IAM)
- **Argo Workflows**: Automatisierung von operationalen Abläufen und Audits
- **Jira Cloud & Slack**: Zentrales Incident-Management und Echtzeit-Monitoring

---

## Funktionen

### GitOps & Infrastructure as Code (IaC)
- **Kustomize Overlay Management**: 
  Implementierung einer modularen Konfigurationsstruktur durch Trennung von `base` und `overlays` (z. B. dev, production). Dies ermöglicht eine saubere Trennung der Konfigurationen und hohe Wiederverwendbarkeit nach dem DRY-Prinzip.
- **Sicheres Secret-Management mit Sealed Secrets**: 
  Integration von Bitnami Sealed Secrets zur Lösung des "Secrets-in-Git"-Problems. Sensible Daten werden asymmetrisch verschlüsselt im Repository gespeichert und erst innerhalb des Clusters durch den Controller dechiffriert.

### CI/CD-Integration & Shift-Left Security
- **Automatisierte CI-Pipeline**: 
  Implementierung von GitHub Actions zur automatischen Validierung von Code-Änderungen. Die Pipeline wird bei jedem Push oder Pull Request getriggert, um Sicherheitsstandards bereits in der Entwicklungsphase zu erzwingen.
- **Vulnerability Scanning as a Service**:
  Integration von Trivy in den GitHub-Workflow. Container-Images werden vor dem Deployment gescannt, wobei die Pipeline bei Funden von CRITICAL oder HIGH Schwachstellen automatisch stoppt (Security Gate).
- **Sichtbarkeit durch Security Dashboards**:
  Konfiguration des Exports von Scan-Ergebnissen im SARIF-Format (Static Analysis Results Interchange Format). Dies ermöglicht die Visualisierung von Schwachstellen direkt im GitHub "Security"-Tab inklusive detaillierter Korrekturanweisungen und CVE-Verweise.

### Security Integration & Vulnerability Management
- **Intelligentes Jira-Ticket-System**: 
  Automatisierte Erstellung von Jira-Tasks bei Erkennung von KRITISCHEN Schwachstellen. Die Integration nutzt die Jira REST API v3 zur nahtlosen Übertragung von Sicherheitsbefunden in den Entwicklungs-Workflow.
- **Idempotenz & Deduplizierung**:
  Ein Python-basierter Logik-Layer prüft vor jeder Ticket-Erstellung via JQL (Jira Query Language), ob für eine spezifische CVE und ein spezifisches Image bereits ein offenes Ticket existiert. Dies verhindert redundante Benachrichtigungen und Ticket-Wildwuchs.
- **Trivy-Laufzeit-Optimierung**:
  Konfiguration von erweiterten Timeouts (15m) für die Analyse komplexer und großformatiger Images (z. B. Keycloak), um vollständige Scans auch bei tiefen Layer-Strukturen sicherzustellen.

### Automated Operations & Maintenance
- **Ressourcen-Optimierung durch Daily Cleanup**: 
  Automatisierte Bereinigung abgeschlossener Argo Workflows zur Entlastung der Cluster-Ressourcen. Ein dedizierter CronWorkflow identifiziert und entfernt Workflows, die älter als 24 Stunden sind.
- **Echtzeit-Benachrichtigung via Slack**: 
  Integration eines Feedback-Kanals für operationale Aufgaben. Nach Abschluss der Bereinigungsprozesse sendet ein spezialisierter Container (`curlimages/curl`) Statusmeldungen inklusive Zeitstempel an einen definierten Slack-Channel.

---

## Containerisierung
Für die Ausführung der Security-Audits und Maintenance-Tasks wurden spezialisierte Images verwendet:
- **Image**: `trivy-python-scanner:0.1`
- **Inhalt**: 
  - Basis: `python:3.9-slim` für minimale Angriffsfläche.
  - Integration von `Trivy` (v0.48.1+) als binäre Komponente.
  - Vorinstallierte Python-Libraries (`requests`) für die API-Kommunikation mit Jira und Slack.
  - Optimiertes Shell-Parsing zur Vermeidung von Fehlinterpretationen bei multiplen Scan-Targets.
- **Maintenance & Messaging**:
  - `bitnami/kubectl` für API-Interaktionen innerhalb des Clusters.
  - `curlimages/curl` für leichtgewichtige HTTP-Benachrichtigungen an Slack.

---

## Automatisierung & Zeitsteuerung (CronWorkflows)
Die operationalen Tasks sind als CronWorkflows konfiguriert (Timezone: Europe/Berlin):
- **Daily Workflow Cleanup & Slack Notification**: Täglich um 00:00 Uhr.
- **Keycloak Security Audit**: Täglich um 00:00 Uhr.
- **Trivy Vulnerability Scan & Jira Sync**: Täglich um 02:00 Uhr.
- **Externer Endpunkt- & SSL-Check**: Täglich um 04:00 Uhr.
- **Pod Health Check**: Stündlich zur Minute 0.

---

## Lernziele & Kenntnisse
- **GitHub Actions & CI/CD**: Aufbau automatisierter Workflows zur Durchsetzung von Security-Policies und Integration von SARIF-Reports in das GitHub-Ökosystem.
- **GitOps-Methodik**: Vollständige Synchronisation des Cluster-Zustands über Git mittels Argo CD.
- **Secret-Lifecycle-Management**: Sicherer Umgang mit Credentials in öffentlichen Repositories durch Verschlüsselung auf Clusterebene (Sealed Secrets).
- **Kustomize-Architektur**: Aufbau und Verwaltung von Multi-Environment-Strategien unter Verwendung von Overlays.
- **Incident Management Automatisierung**: Integration von Security-Scannern in Enterprise-Ticketing-Systeme (Jira) und Messaging-Plattformen (Slack).
- **Problembehandlung in komplexen Pipelines**: Debugging von Netzwerk-Timeouts, Shell-Escaping in YAML-Manifesten und Secret-Synchronisationsprozessen.