# My DevSecOps Platform

##  Übersicht
Dieses Projekt zeigt den Aufbau einer lokalen DevSecOps-Plattform auf Basis von Kubernetes.  
Ziel ist es, typische DevOps- und Security-Tools in einer Umgebung zu integrieren und praktisch anzuwenden.

---

##  Architektur
Die Plattform basiert auf einer Kubernetes-Umgebung und integriert mehrere Tools aus den Bereichen Deployment, Monitoring und Security:

- Kubernetes (lokales Cluster)
- Argo CD (GitOps Deployment)
- Helm (Applikationsmanagement)
- Prometheus (Monitoring)
- Grafana (Visualisierung)
- Falco (Runtime Security)
- Trivy (Vulnerability Scanning)

Zusätzlich wurden erste Erfahrungen mit folgenden Technologien gesammelt:
- Keycloak (Identity & Access Management)
- Argo Workflows (Workflow-Automatisierung)

---

##  Funktionen

###  GitOps Deployment
- Anwendungen werden über Argo CD automatisch aus Git-Repositories deployt  
- Änderungen im Repository werden direkt im Cluster synchronisiert  

###  Monitoring & Observability
- Prometheus sammelt Metriken aus dem Cluster  
- Grafana visualisiert die Daten in Dashboards  
- Alerts können definiert und getestet werden  

###  Security Integration
- Falco überwacht das Laufzeitverhalten von Containern  
- Trivy scannt Container-Images auf Schwachstellen  

---

##  Lernziele
Dieses Projekt wurde erstellt, um praktische Erfahrungen in folgenden Bereichen zu sammeln:

- Kubernetes Deployment und Troubleshooting  
- Helm Charts und Konfigurationsmanagement  
- GitOps mit Argo CD  
- Monitoring mit Prometheus & Grafana  
- Security-Tools im DevSecOps-Kontext  

---

##   Setup (Kurzbeschreibung)

### Voraussetzungen
- Docker
- kubectl
- Helm
- Kubernetes Cluster (z. B. kind oder k3s)

### Installation (Beispiel)
```bash
# Cluster erstellen
kind create cluster

# Argo CD installieren
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Zugriff (Port Forward)
kubectl port-forward svc/argocd-server -n argocd 8080:443
