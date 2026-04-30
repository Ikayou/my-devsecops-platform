# DevSecOps Plattform auf Kubernetes
**Automatisierung von Deployment, Security und Monitoring**

## Übersicht
Dieses Projekt zeigt den Aufbau einer modernen Infrastruktur, die Sicherheit und Betrieb (Ops) direkt verbindet. Das Ziel ist ein vollständig automatisierter Prozess – von der Code-Änderung bis zur Überwachung im laufenden Betrieb.

## Kern-Funktionen

### 1. GitOps & Automatisierung
*   **Argo CD & Root-App**: Die gesamte Plattform wird über eine `root-app.yaml` gesteuert. Sobald ich Änderungen nach GitHub pushe, synchronisiert Argo CD den Cluster automatisch.
*   **Strukturierte Konfiguration**: Ich nutze **Kustomize** mit `base` und `overlays`. Das macht die Konfiguration modular und bereit für verschiedene Umgebungen (z. B. Dev und Produktion).
*   **Sichere Secrets**: Passwörter werden mit **Sealed Secrets** verschlüsselt. So können sie sicher im öffentlichen Git-Repository gespeichert werden.

![ArgoCD](bilder/argocd.png)

### 2. Security & Incident Management
*   **Automatisierte Scans**: Ein spezialisierter **Trivy-Scanner** (basiert auf Python 3.9-slim) prüft die Applikationen regelmäßig auf Schwachstellen.

![ArgoWorkflows](bilder/ArgoWorkflows.png)

*   **Smart Ticketing**: Findet der Scanner kritische Fehler, prüft ein Skript automatisch in **Jira**, ob das Problem bekannt ist. Falls nicht, wird ein Ticket erstellt und eine **Slack-Warnung** gesendet.

![Jira](bilder/Jira-Ticket.png)

![Slack](bilder/slack.png)

*   **Compliance-Check**: Ein Workflow prüft in **Keycloak**, ob alle Benutzer die Multi-Faktor-Authentifizierung (MFA) aktiviert haben.

### 3. Monitoring & Plattform-Betrieb
*   **Echtzeit-Überwachung**: Mit **Prometheus, Grafana, Loki und Falco** werden Metriken, Logs und Sicherheits-Events zentral visualisiert.
*   **Verfügbarkeit**: Ein **SSL-Monitor** prüft die Gültigkeit von Zertifikaten und meldet Ablaufdaten proaktiv an Slack.
*   **Self-Healing**: Ein Workflow erkennt abgestürzte Pods sofort. Zudem bereinigt ein automatischer **Cleanup-Workflow** täglich alte Daten, um Ressourcen zu sparen.

---

## Warum dieser Aufbau?
*   **Spezialisierte Images**: Der `trivy-scanner` wurde bewusst als schmales Python-Image gebaut, um die Angriffsfläche klein zu halten und nur nötige Funktionen (Jira/Slack API) zu enthalten.
*   **Shift-Left**: Durch die Integration von **GitHub Actions** werden Sicherheitslücken bereits erkannt, bevor die Software installiert wird.

## Lernergebnisse
*   Sicherer Betrieb von Kubernetes-Clustern durch GitOps-Prinzipien.
*   Automatisierung komplexer Arbeitsabläufe mit **Argo Workflows**.
*   Praktische Erfahrung in der Verknüpfung von Security-Tools mit Enterprise-Systemen wie Jira und Slack.

---