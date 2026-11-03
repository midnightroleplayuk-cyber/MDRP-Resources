# Duty card backgrounds / Dienstausweis-Hintergründe

## Deutsch

Die Ausweis-Hintergründe werden direkt aus diesem Ordner geladen und nicht in das
Frontend eingebaut. Bestehende Bilder kannst du unter demselben Dateinamen ersetzen.

Für einen neuen Job legst du `card_<jobname>.webp` oder `card_<jobname>.png` hier ab,
zum Beispiel `card_highwaypatrol.webp` für den Job `highwaypatrol`. Verwende den
technischen Jobnamen aus `/jobconfig`, nicht die angezeigte Bezeichnung. Namen werden
kleingeschrieben und Leerzeichen durch Unterstriche ersetzt. Off-Duty-Jobs verwenden
den zugehörigen On-Duty-Jobnamen.

Die Suche erfolgt in dieser Reihenfolge:

1. `card_<jobname>.webp`, dann `.png`
2. `card_<jobgruppe>.webp`, dann `.png` (z. B. `card_police.webp`)
3. Eigener Standard: `employee_card.webp`, dann `.png`
4. Mitgelieferter neutraler Standard: `employee_card.svg`

Wenn beide Formate vorhanden sind, hat WebP Vorrang. Ohne eigenes Bild wird die
mitgelieferte Standardkarte verwendet. Name, Rang und Station werden weiterhin von
der Oberfläche über das Bild gelegt. Nutze am besten das Seitenverhältnis der
vorhandenen Bilder (ungefähr 3:2).

Nach dem Hinzufügen oder Austauschen von Bildern die Resource `sky_jobs_base`
neu starten und den Ausweis erneut öffnen. Ein Frontend-Build ist nicht nötig.
Bei Arbeit im Entwicklungsrepository werden die Bilder mit `build_copy.bat`
auf die lokalen Server kopiert. Bearbeite die Bilder im Repository, damit spätere
Kopiervorgänge deine Änderungen nicht überschreiben.

## English

These images load directly from this folder without a frontend rebuild. Replace an
existing image under the same filename, or add `card_<jobname>.webp` / `.png` for a
custom job (for example, `card_highwaypatrol.webp`). Use the technical job name from
`/jobconfig`, lowercase with spaces replaced by underscores. Off-duty jobs use their
mapped on-duty job name.

The lookup order is the job name, then its job group, then a custom
`employee_card` default; WebP is tried before PNG for each. The included neutral
`employee_card.svg` is used when no custom image loads. Player details are rendered over the
image. Match the existing images' approximate 3:2 aspect ratio.

Restart `sky_jobs_base` after adding or replacing images, then reopen the card.
When working in the development repository, use `build_copy.bat` to deploy your
changes. Edit the repository copy so a later deployment does not overwrite them.
