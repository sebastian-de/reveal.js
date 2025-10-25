<!-- .slide: data-auto-animate -->

## Kontextfenster
### von Large Language Models

---
<!-- .slide: data-auto-animate -->

### Was macht ein Large Language Model?
- Wird mit sehr viel Text trainiert
- Text kann alles sein: Prosa, Programmcode, etc.
- Kann daraus ableiten, wie der Text des Trainingsmaterials aussieht.
- Kann damit Text produzieren, der dem Trainingsmaterial ähnelt.

---
<!-- .slide: data-auto-animate -->

### Kontextfenster
Maximale Textlänge, die ein LLM als Nutzereingabe verarbeiten kann.

<small>_"Kurzzeitgedächtnis"_</small>

---
<!-- .slide: data-auto-animate -->

#### Fiktives Beispiel
### 6-Wort-Modell
Kontextfenster: 6 Wörter

---
<!-- .slide: data-auto-animate -->

### 6-Wort-Modell
Die beste Pizza gibt es in

<span style="color:dodgerblue">`_____`</span>

---
<!-- .slide: data-auto-animate -->

### 6-Wort-Modell
Die beste Pizza gibt es in

<span style="color:dodgerblue">Italien</span>

---
<!-- .slide: data-auto-animate -->

### 6-Wort-Modell
Die beste Pizza mit Sardellen gibt es in

<span style="color:dodgerblue">`_____`</span>

---
<!-- .slide: data-auto-animate -->

### 6-Wort-Modell
<span style="color:red">Die beste</span> Pizza mit Sardellen gibt es in

<span style="color:dodgerblue">`_____`</span>

---
<!-- .slide: data-auto-animate -->

### 6-Wort-Modell
Pizza mit Sardellen gibt es in

<span style="color:dodgerblue">`_____`</span>

---
<!-- .slide: data-auto-animate -->

### 6-Wort-Modell
Pizza mit Sardellen gibt es in

<span style="color:dodgerblue">fast jeder Pizzeria</span>

---
<!-- .slide: data-auto-animate -->

### Kontextfenster
- Ist bei aktuellen LLMs sehr lang
- Entspricht einem Buch von mehreren hundert Seiten Text

---
<!-- .slide: data-auto-animate -->

### Kontextfenster
Aber: Tatsächlich verfügbare Länge begrenzt

(z. B. durch System-Prompt)

---
<!-- .slide: data-auto-animate -->

### Kontextfenster
Daher:
- Zur Verfügung gestellte Dokumente begrenzen
- Bei langen Texten nur relevante Kapitel hochladen
- Lange Chats vermeiden