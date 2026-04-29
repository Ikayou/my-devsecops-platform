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
- **Helm**: Paketmanagement für Kubernetes-Applikationen
- **Prometheus & Grafana**: Monitoring, Metriken und Visualisierung
- **Falco & Trivy**: Runtime Security und Vulnerability Scanning
- **Keycloak**: Identity & Access Management (IAM)
- **Argo Workflows**: Automatisierung von operationalen Abläufen und Audits
- **Jira Cloud**: Zentrales Incident-Management für Sicherheitslücken

---

## Funktionen

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

### Automated Operations & Security Audits
- **Detailliertes Schwachstellen-Management (Trivy-Audit)**:
  Automatisierter Scan von Container-Images auf kritische Sicherheitslücken. Der Audit identifiziert betroffene Pakete, installierte Versionen sowie verfügbare Fix-Versionen zur sofortigen Risikobewertung.
- **Echtzeit-Benachrichtigung via Slack & Jira**:
  Kritische Audit-Ergebnisse werden simultan als Jira-Task angelegt und via Slack-Webhook gemeldet. Die Benachrichtigungen enthalten direkte Details zur CVE, dem betroffenen Image und dem Schweregrad.

---

## Containerisierung
Für die Ausführung der Security-Audits wurde ein dediziertes Custom-Image entwickelt:
- **Image**: `trivy-python-scanner:0.1`
- **Inhalt**: 
  - Basis: `python:3.9-slim` für minimale Angriffsfläche.
  - Integration von `Trivy` (v0.48.1+) als binäre Komponente.
  - Vorinstallierte Python-Libraries (`requests`) für die API-Kommunikation mit Jira und Slack.
  - Optimiertes Shell-Parsing zur Vermeidung von Fehlinterpretationen bei multiplen Scan-Targets.

---

## Automatisierung & Zeitsteuerung (CronWorkflows)
Die operationalen Tasks sind als CronWorkflows konfiguriert:
- **Keycloak Security Audit**: Täglich um 00:00 UTC.
- **Trivy Vulnerability Scan & Jira Sync**: Täglich um 02:00 UTC (Timezone: Asia/Tokyo / Europe/Berlin).
- **Externer Endpunkt- & SSL-Check**: Täglich um 04:00 UTC.
- **Pod Health Check**: Stündlich zur Minute 0.

---

## Lernziele & Kenntnisse
- **GitHub Actions & CI/CD**: Aufbau automatisierter Workflows zur Durchsetzung von Security-Policies und Integration von SARIF-Reports in das GitHub-Ökosystem.
- **Incident Management Automatisierung**: Integration von Security-Scannern in Enterprise-Ticketing-Systeme (Jira).
- **API-Programmierung**: Entwicklung von Python-Logik zur Interaktion mit REST-Schnittstellen unter Berücksichtigung von Authentifizierung (Basic Auth / Tokens).
- **Datenkonsistenz**: Implementierung von Suchlogiken zur Vermeidung von Daten-Duplikaten in automatisierten Pipelines.
- **Docker-Engineering**: Erstellung spezialisierter Multi-Tool-Images für CI/CD-Workflows.
- **Problembehandlung in komplexen Pipelines**: Debugging von Netzwerk-Timeouts, DNS-Problemen und Argument-Parsing in containerisierten Umgebungen.