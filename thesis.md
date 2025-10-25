<!-- .slide: data-auto-animate -->

<img class="r-stretch" src="images/k8s_logo_with_border.svg" alt="Kubernetes">

### Implementierung eines Sicherheitskonzepts für den Betrieb medizinischer Software in einer Cloud-Infrastruktur auf Basis von Kubernetes

Masterarbeit

<small>von Sebastian Fleer</small>

---
<!-- .slide: data-auto-animate -->

## Agenda

1. Motivation und Stand der Forschung
1. Methoden und Ergebnisse
1. Diskussion und Ausblick

Note:
- etwa 5 Minuten Motivation
- 12 Minuten Methoden und Ergebnisse
- 3 Minuten Diskussion und Ausblick.

Der Schwerpunkt liegt bewusst auf dem mittleren Block, dort sitzen die Ergebnisse der Arbeit.

---
<!-- .slide: data-auto-animate -->

## Motivation und Forschungsstand

- Veraltete IT im Gesundheitswesen, Investitionsstau
- Steigende Angriffe auf Gesundheitseinrichtungen
- Cloud als möglicher Teil der Lösung, aber Vorbehalte
- Forschungslücke: praxisnahe Kubernetes-Sicherheit

Note:
- Krankenhausinformationssysteme sind oft über 20 Jahre alt und monolithisch, dazu Fachkräftemangel.
- Die ENISA (Agentur der EU für Cybersicherheit) meldet zunehmende Angriffe auf den Gesundheitssektor.
- Vorbehalte gegen Cloud: Datenschutz und Vendor Lock-in, also die Abhängigkeit vom Anbieter.
- Vorarbeiten: Gen3 (Open-Source-Datenplattform, USA), Charité-Modell, recruIT, GKV Informatik. Neuigkeitswert: ein praxisnaher, durchgängig dokumentierter Weg für Kubernetes im Medizinumfeld.

---
<!-- .slide: data-auto-animate -->

## Aufgabenstellung und Forschungsfrage

- Forschungsfrage: konformer Betrieb mit Bordmitteln
- Zusätzlich gängige Open-Source-Lösungen
- Nebenfrage: Unabhängigkeit vom Cloud-Anbieter
- Rein technisch, produktiver Cluster, ISMS vorausgesetzt
- Anwendungsfall: movisens TherapyDesigner

Note:
Aufgabenstellung: ein technisches Sicherheitskonzept für einen bereits produktiv betriebenen Kubernetes-Cluster entwerfen, implementieren und bewerten. Abgrenzung: nur Softwareebene im Cluster, keine physische Sicherheit, kein Host-Betriebssystem. Ein ISMS (Informationssicherheitsmanagementsystem) wird als etabliert vorausgesetzt. TherapyDesigner erstellt digitale Therapiesysteme, die Medizinprodukte sein können.

---
<!-- .slide: data-background="images/regulatory_affairs.svg" data-background-size="contain" -->

Note:
Überblick über den regulatorischen Themenkomplex: Datenschutz (DSGVO, Art. 9 und 32), Medizinprodukte (MDR, IEC 81001-5-1, ISO 14155), klinische Prüfungen (ICH E6 R3), IT-Sicherheit (NIS-2, CRA), Cloud (BSI C5, BSI TR-03161). Aus den Dokumenten wurden zehn technische Kernthemen destilliert, etwa Zugriffskontrolle, Verschlüsselung und Protokollierung. Die IG-NB-Fragebögen dienten als Orientierung für die Auswahl.

---
<!-- .slide: data-background="images/td_architecture.dot.svg" data-background-size="contain" -->

Note:
Untersuchungsgegenstand: die serverseitigen Komponenten der Plattform als Container in Managed Kubernetes bei einem Public-Cloud-Anbieter. Der TherapyManager besteht aus Hasura (GraphQL-Engine über dem Datenbankschema) und einem eigenen Backend. Der TherapyExecutor führt die konfigurierte Therapie aus, eine Instanz je Studie mit dedizierter PostgreSQL-Datenbank. Keycloak übernimmt die Authentifizierung aller Nutzenden. Jede Komponente besitzt eine eigene Datenbank. Die clientseitige TherapyApp ist ausgeklammert.

---
<!-- .slide: data-background="images/security_concept_context.dot.svg" data-background-size="contain" -->

Note:
Vorgehen in vier Stufen nach Angermeier: Untersuchungsgegenstand modellieren, Schutzbedarf feststellen, Bedrohungen analysieren, Risiken analysieren. Abgrenzung: IT-Sicherheits-Betriebssicht statt Risikomanagement der Produktentwicklung, da der Cluster bereits produktiv läuft. Wichtig: Das Sicherheitskonzept verändert das System selbst, daher ist eine zyklische Re-Evaluierung eingeplant.

---
<!-- .slide: data-background="images/tm-detail-k8s.svg" data-background-size="contain" -->

Note:
Datenflussdiagramm, erzeugt mit der Python-Bibliothek pytm. Fokus auf drei Vertrauensgrenzen: erstens öffentliches Internet zum Gateway Controller, zweitens Anwendungs-Pods zur Control Plane, drittens Komponenten zu ihren Datenspeichern. Konzeptionelle Grenze: Das Diagramm ist statisch, Kubernetes-Objekte sind flüchtig und dynamisch verteilt. Das DFD dient daher als Einstiegsartefakt, nicht als Bewertungsgrundlage.

---
<!-- .slide: data-auto-animate -->

## Bedrohungen analysieren

- Threat Matrix for Kubernetes (MITRE ATT&CK)
- 40 Bedrohungen, 32 Maßnahmen
- Sechs Bedrohungen nicht anwendbar
- Anwendbarkeit per Anbieter-Anfrage geklärt

Note:
Die Matrix von Microsoft baut auf MITRE ATT&CK auf, einer Wissensbasis realer Angriffstechniken. Abgrenzung gegen Alternativen: STRIDE liefert viele Falsch-Positive, Attack Trees erfordern hohe Expertise, für FAIR fehlen Häufigkeits- und Schadensdaten. Nicht anwendbar sind providerspezifische Bedrohungen wie Managed Identities oder der Instance Metadata Service, schriftlich beim Cloud-Anbieter geklärt.

---
<!-- .slide: data-background="images/tm_priorisierung_dateien.dot.svg" data-background-size="contain" -->

Note:
Eigenes Score-Modell als Python-Skript mit drei CSV-Eingaben: Bedrohungskatalog, Maßnahmenkatalog und Schutzbedarf der Komponenten. Score je Bedrohung: höchster Wert der Schutzziele Vertraulichkeit, Integrität, Verfügbarkeit (CIA) der primär betroffenen Komponente, nach dem Worst-Case-Prinzip. Maßnahmen-Score: Summe über alle adressierten anwendbaren Bedrohungen. Erfüllt die Angermeier-Kriterien Nachvollziehbarkeit, Wiederholbarkeit, Vergleichbarkeit und Anpassbarkeit.

---
<!-- .slide: data-auto-animate -->

## Abgleich mit der Regulatorik

- Zehn Kernthemen den Maßnahmen zugeordnet
- Fünf Kernthemen ohne direkte Entsprechung
- Lücken: Logging, Verschlüsselung, Effektivitätstests
- Fünf ergänzende Maßnahmen ins Konzept

Note:
Die Matrix deckt die regulatorischen Anforderungen nicht vollständig ab. Fehlend: cluster-weite Metriken und Logs, Scans laufender Container, Encryption at Rest, versionierte Konfiguration und Effektivitätsprüfungen. Ergänzt werden: Observability-Stack, SBOM-Prüfung (SBOM: maschinenlesbare Inventarliste aller Softwarekomponenten), Verschlüsselung von etcd (dem Zustandsspeicher von Kubernetes) und Volumes, Infrastructure-as-Code sowie periodische Tests.

---
<!-- .slide: data-auto-animate -->

## Umsetzung: Network Policies

- Default-Deny für Ingress und Egress
- DNS-Auflösung als einzige Ausnahme
- Allowlist pro Service über Pod-Labels
- Executor-Datenbanken instanzweise getrennt
- Limitation: Egress 443/TCP für Firebase

Note:
Kubernetes setzt Network Policies nicht selbst durch, das übernimmt das CNI (Container Network Interface), hier Calico. Jede Datenbank akzeptiert nur ihren zugehörigen Dienst, die Studiendaten sind instanzweise isoliert. Die Egress-Freigabe ist nötig für Push-Nachrichten über Google Firebase: DNS-basierte Regeln fehlen nativ, Calico bietet sie nur in der Enterprise-Version, Google nennt keine IP-Bereiche. Lösungsansatz: ein dediziertes Push-Gateway.

---
<!-- .slide: data-auto-animate -->

## Umsetzung: Zugriffskontrolle

- Menschen sind keine Kubernetes-Objekte
- Keine OIDC-Anbindung beim Cloud-Anbieter
- ServiceAccounts mit kurzlebigen Tokens
- Rollen: Administration, Entwicklung, Support
- Berechtigungen als OpenTofu-Code

Note:
Anforderungen: Personenzuordnung im Audit-Log, Least Privilege, begrenzte Gültigkeit, sofortige Sperrbarkeit. Client-Zertifikate verworfen, da Kubernetes keinen Widerruf kennt. OIDC (OpenID Connect) zur delegierten Authentifizierung scheidet aus, der Anbieter unterstützt es nicht. Lösung: ServiceAccounts für Mitarbeitende in einem eigenen Namespace, Rollen und Bindings vollständig als OpenTofu-Code versioniert.

---
<!-- .slide: data-background="images/token-self-service.svg" data-background-size="contain" -->

Note:
Eigenleistung: Token-Self-Service-Backend in Python. Mitarbeitende fordern kurzlebige Tokens selbst an. Die Authentifizierung erfolgt über ein OAuth-2.0-Zugriffstoken, die Identität aus dem Email-Claim des JWT (signiertes Token), validiert über den JWKS-Endpunkt des Autorisierungsservers. Das Backend leitet daraus den ServiceAccount-Namen ab und stellt beim API-Server ein Token mit definierter Laufzeit aus. Auslieferung als Distroless-Image ohne Shell und Paketmanager.

---
<!-- .slide: data-auto-animate -->

## Umsetzungsstand und Abdeckung

| Abdeckung | Kernthemen | Beispiele |
| --- | --- | --- |
| vollständig | 4 | Zugriffskontrolle, Datensicherung |
| teilweise | 5 | Protokollierung, Datenverschlüsselung |
| nicht umgesetzt | 1 | Effektivitätstests |

Dazu 15 Maßnahmen der Threat Matrix implementiert

<small>Vollständige Tabelle in Kapitel 7.3 der Arbeit</small>

Note:
Vollständig abgedeckt: rollenbasierte Zugriffskontrolle, Schutz vor unerwünschten Netzwerkzugriffen, Datensicherung und Konfigurationsmanagement. Teilweise: Schwachstellenmanagement, Schadsoftware, Protokollierung, Datenverschlüsselung und Angriffserkennung. Über die zehn Erstumsetzungs-Maßnahmen hinaus wurden fünf weitere umgesetzt, darunter der Verzicht auf Klartext-Zugangsdaten und ein ARP-sicheres CNI.

---
<!-- .slide: data-auto-animate -->

## Limitierungen und Restrisiken

- Keine Echtzeit-Auswertung der Audit-Logs
- Egress-Freigabe für Executor-Instanzen
- Schlüsselhoheit beim Cloud-Anbieter
- Keine Effektivitätsprüfungen

Note:
Kompensationen: Metriken und Anwendungs-Logs machen Anomalien sichtbar. Pod-Härtung und instanzweise Trennung begrenzen die Ausbreitung eines kompromittierten Executors. Backups sind unabhängig vom Anbieter clientseitig verschlüsselt. Die Ursachen der Lücken liegen überwiegend im Leistungsumfang des Cloud-Angebots, nicht in fehlenden Möglichkeiten der eingesetzten Software.

---
<!-- .slide: data-auto-animate -->

## Methodenreflexion und Übertragbarkeit

- Threat Matrix bewährt, aber lückenhaft
- Keine Risikobewertung in der Matrix
- Score nivelliert durch hohen Schutzbedarf
- Vorgehen und Maßnahmen übertragbar

Note:
Verworfen: eine Kopplung von ATT&CK-Taktiken an CIA-Schutzziele, weil keine Literatur deren Validität stützt. Gegen FAIR entschieden: fehlende Datenbasis und nötiges Spezialwissen, das Vorgehen soll auch für kleine Teams anwendbar bleiben. Das Scoring-Skript ist generisch, die Maßnahmen beruhen auf Kubernetes-Bordmitteln und sind cloudagnostisch. Umgebungsspezifisch bleiben Token-Self-Service und die Audit-Log-Einschränkung.

---
<!-- .slide: data-auto-animate -->

## Fazit und Ausblick

- Forschungsfrage bejaht, mit Einschränkungen
- Lücken im Leistungsumfang des Anbieters
- Anbieterunabhängigkeit gegeben, nicht absolut
- Konsequenz: Anbieterfähigkeiten vorab klären
- Ausblick: Supply-Chain, Penetrationstests, Re-Evaluierung

Note:
Erkenntnisfortschritt: ein praxisnaher, nachvollziehbar dokumentierter Weg von der Bedrohungsanalyse über die Priorisierung bis zur Umsetzung, auch für kleine Teams. Nächster Schritt laut Neubewertung: MS-M9005.003, ein Gate für deployte Images, schließt die Absicherung der Lieferkette. Die Einschränkungen des Anbieters waren nicht öffentlich dokumentiert, daher Anforderungen vor der Anbieterwahl klären.

---
<!-- .slide: data-auto-animate -->

## Vielen Dank

Note:
Kurzer Abschluss, dann Übergang in die Fragerunde. Dahinter liegen Zusatzfolien als Reserve für vertiefende Fragen.

---
<!-- .slide: data-auto-animate -->

## Zusatzfolien

Note:
Reserve für die Fragerunde, nicht Teil des Vortrags.

---
<!-- .slide: data-background="images/kubernetes_architecture.dot.svg" data-background-size="contain" -->

Note:
Aufbau eines Clusters: Die Control Plane mit API-Server, etcd (Zustandsspeicher), Scheduler und Controller Manager steuert das Cluster. Worker Nodes mit kubelet und kube-proxy führen die eigentlichen Pods aus. Bei Managed Kubernetes betreibt der Anbieter die Control Plane, eigener Gestaltungsspielraum liegt bei den Nodes und Workloads.

---
<!-- .slide: data-background="images/k8s_pod_namespaces.dot.svg" data-background-size="contain" -->

Note:
Container beruhen auf Linux-Namespaces (Isolierung von Prozessen, Netzwerk und Dateisystem) und cgroups (Ressourcenbegrenzung). Alle Container eines Nodes teilen denselben Kernel. Deshalb ist eine zu großzügige Pod-Konfiguration die häufigste Ursache für Container Breakouts, also das Ausbrechen auf den Host. Das begründet die Pod-Härtung im Konzept.

---
<!-- .slide: data-background="images/k8s-gateway.svg" data-background-size="contain" -->

Note:
Zugriff von außen über die Gateway-API: Die GatewayClass legt die implementierende Komponente fest, Gateway-Objekte definieren Listener für Ports und Hostnamen, HTTPRoutes leiten nach Kriterien wie dem Pfad an Services weiter. TLS wird am Gateway terminiert. Erlaubt sind TLS 1.2 und 1.3, für 1.2 nur Cipher-Suites nach Empfehlung der BSI TR-02102-2, konfiguriert über eine Envoy ClientTrafficPolicy der Calico-Implementierung.

---
<!-- .slide: data-auto-animate -->

## Schutzbedarf der Komponenten (Auszug)

| Komponente | C | I | A |
| --- | --- | --- | --- |
| TherapyExecutor | hoch | hoch | hoch |
| kube-apiserver | hoch | hoch | mittel |
| etcd | hoch | hoch | mittel |
| Gateway Controller | hoch | hoch | hoch |
| Container Registry | niedrig | hoch | mittel |
| Observability-Stack | niedrig | hoch | mittel |

<small>Auszug aus zwei Tabellen in Kapitel 5.1 der Arbeit</small>

Note:
Qualitative Einstufung entlang Vertraulichkeit, Integrität und Verfügbarkeit. Alle Applikationskomponenten sind durchgängig hoch eingestuft, daher eignet sich die Applikationssicht nicht zur Priorisierung. Die Cluster-Sicht differenziert: Die Verfügbarkeit von API-Server und etcd ist mittel, da ein Ausfall den Betrieb stoppt, aber keine Daten verletzt. Die Zeile Workloads bündelt das Maximum aller TherapyDesigner-Komponenten.

---
<!-- .slide: data-auto-animate -->

## Scoring vor und nach der Implementierung

Vorher

| Maßnahme | Score |
| --- | --- |
| MS-M9003 Least Privilege | 48 |
| MS-M9005.003 Image-Gate Deployment | 27 |
| MS-M9014 Network Segmentation | 18 |

Nachher

| Maßnahme | Score |
| --- | --- |
| MS-M9005.003 Image-Gate Deployment | 27 |
| MS-M9011 LSM-Laufzeitschutz | 21 |
| MS-M9002 API-Server-Firewall | 15 |

<small>Auszug, vollständige Tabellen in Kapitel 5.1 und 7.2 der Arbeit</small>

Note:
Neubewertung mit demselben Skript, einzige Änderung: umgesetzte Maßnahmen als implementiert markiert. Die 15 umgesetzten Maßnahmen entfallen, die Scores der verbliebenen bleiben unverändert. Der Schwerpunkt wandert von der Cluster-Konfiguration zur Software-Lieferkette. MS-M9011 und MS-M9002 hängen vom Kernel und dem Firewall-Angebot des Anbieters ab.

---
<!-- .slide: data-auto-animate -->

## Observability-Stack

- Prometheus: Metriken per Pull
- Loki und Alloy: zentrale Logs
- Grafana: Dashboards als ConfigMaps
- Alertmanager: Alarme nach Kritikalität
- Audit-Log extern in S3 gespeichert

Note:
Zuerst implementiert, weil Observability die Grundlage ist, um die Wirksamkeit aller weiteren Maßnahmen zu prüfen. Prometheus fragt Metrik-Endpunkte ab, Alloy sammelt Logs als DaemonSet und sendet sie an Loki. Das Audit-Log des API-Servers protokolliert jede Anfrage mit Identität und Ressource. Der Anbieter erlaubt nur den Export in einen S3-Bucket, daher ist keine Echtzeitauswertung möglich.

---
<!-- .slide: data-auto-animate -->

## Datensicherung

- CronJobs mit pg_dump je Datenbank
- Clientseitige Verschlüsselung mit age
- Ablage in externem S3-Objektspeicher
- Wiederherstellung manuell per Skript

Note:
Basiert auf dem Open-Source-Skript postgresql-backup-s3, erweitert um asymmetrische Verschlüsselung: Im Backup-Job liegt nur der öffentliche Schlüssel, der geheime Schlüssel wird ausschließlich bei der Wiederherstellung benötigt. Der Backup-Speicher ist vom Cluster getrennt. Damit ist MS-M9031 umgesetzt, die Snapshot-Fähigkeit des Storage-Providers wird nicht benötigt.

---
<!-- .slide: data-auto-animate -->

## Verschlüsselung in transit und at rest

- WireGuard zwischen Nodes über Calico
- Node-interner Verkehr unverschlüsselt
- Volumes: AES-XTS, 256 Bit, providerseitig
- etcd: AES-CBC, nicht mehr empfohlen
- Schlüsselhoheit beim Anbieter

Note:
Ein Service Mesh wurde bewusst verworfen: höhere Latenz und Ressourcenverbrauch, mehr Komplexität und Angriffsfläche. Single-Tenant-Nodes und Pod-Härtung senken das Risiko interner Angriffe. AES-CBC in etcd gilt wegen Padding-Oracle-Angriffen als veraltet, der externe Angriffsvektor entfällt, weil der Anbieter etcd ohne direkten Zugriff betreibt. Backups sind unabhängig davon clientseitig verschlüsselt.

---
<!-- .slide: data-auto-animate -->

## Pod Security Admission

- Drei Profile: Privileged, Baseline, Restricted
- Drei Modi: enforce, audit, warn
- Schrittweise Einführung bis Restricted
- Kein ServiceAccount-Auto-Mount
- Requests und Limits für alle Container

Note:
Die Pod Security Admission ist der eingebaute Admission Controller von Kubernetes und wird über Namespace-Labels konfiguriert. Vorgehen: erst Baseline erzwingen und parallel auf Restricted prüfen, Verstöße über das Audit-Log beheben, dann auf Restricted anheben. Anpassungen waren bei privilegierten Ports nötig. Generische Policy-Engines wie Gatekeeper oder Kyverno wurden nicht benötigt.

---
<!-- .slide: data-auto-animate -->

## Re-Evaluierung

- Maßnahmen verändern das untersuchte System
- Neue Komponenten sind neue Angriffsziele
- Token-Backend privilegiert und eigenentwickelt
- Nächster Zyklus mit aktualisiertem Ist-Zustand

Note:
Der implementierte Zustand ist der Untersuchungsgegenstand der nächsten Analyse. Besonderes Risiko: Das Token-Backend fordert Tokens für beliebige Mitarbeiter-ServiceAccounts an, eine Kompromittierung würde die Berechtigungsarchitektur unterlaufen. Es wird als eigene Komponente ins Datenflussdiagramm aufgenommen. Externe Auslöser: Updates der Threat Matrix, regulatorische Änderungen und Änderungen im Angebot des Anbieters.
