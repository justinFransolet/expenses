# Examen de programmation mobile du 20 janvier 2026

## Objectif

Dans cet examen, vous allez développer une application de gestion des dépenses personnelles.
L'application permettra aux utilisateurs d'ajouter, de visualiser et de supprimer des dépenses.
En outre, l'application permettra d'afficher le total des dépenses dans différentes devises à l'aide de l'API [Frankfurter](https://frankfurter.dev).

### Ajout de dépenses

Pour ajouter une dépense, l'utilisateur clique sur le bouton d'ajout, remplit un formulaire avec les champs titre, montant et catégorie, puis valide.
La dépense est ajoutée à la liste des dépenses et le total des dépenses est mis à jour.

<video src="doc/add-expenses.mov" controls preload></video>

### Édition de dépense

Quand l'utilisateur clique sur une dépense dans la liste, un formulaire pré-rempli avec les informations de la dépense s'affiche.
L'utilisateur peut modifier les informations et valider pour mettre à jour la dépense.
La dépense est mise à jour dans la liste et le total des dépenses est recalculé.

<video src="doc/edit-expense.mov" controls preload></video>

### Suppression de dépense

L'utilisateur peut balayer une dépense vers la gauche pour la supprimer de la liste.
Le total des dépenses est mis à jour en conséquence.

<video src="doc/delete-expense.mov" controls preload></video>

### Conversion de devises

L'utilisateur peut sélectionner une devise différente pour afficher le total des dépenses converti.
L'application utilise l'API [Frankfurter](https://frankfurter.dev) pour obtenir les taux de change et calcule le total des dépenses dans la devise sélectionnée.
Si une erreur de réseau se produit, le total est remplacé par "N/A" pour signaler l'erreur.

<video src="doc/convert-currency.mov" controls preload></video>

## Contraintes techniques

> [!CAUTION]
> Le non-respect de ces contraintes techniques entraînera une pénalité sur votre note finale, voire un zéro pour votre examen.

- Les dépenses doivent être stockées localement sur l'appareil de l'utilisateur, dans une base de données SQLite.
- Respectez l'interface utilisateur (UI) présentée dans les vidéos autant que possible.
- Les données obtenues de manière asynchrone doivent afficher un indicateur de chargement pendant le chargement. En cas d'erreur, un message d'erreur doit être affiché à l'utilisateur (ou "N/A" pour le total des dépenses).
- Partez du squelette de projet fourni et **ne modifiez le code que là où il y a des `TODO`**. En cas de doute, demandez des clarifications à l'examinateur.
- Créez un projet GitHub privé auquel vous inviterez l'examinateur en tant que collaborateur. Poussez votre code régulièrement (**au minimum toutes les 30 minutes**) avec des messages de commit clairs.
- Indiquez votre nom complet dans le fichier `AUTHOR`.
- Votre code ne devrait contenir aucun avertissement ou erreur de compilation. Ne modifiez pas le fichier `analysis_options.yaml` et n'ajoutez pas de commentaires pour ignorer les avertissements.
- N'ajoutez pas de dépendances externes autres que celles déjà présentes dans le fichier `pubspec.yaml` du squelette de projet.

## Modalités

L'examen dure 3 heures.

L'examen est individuel. Vous ne pouvez pas collaborer avec d'autres humains.

L'examen est à cahier ouvert. Vous pouvez consulter vos notes, et toute ressource en ligne, en ce compris une intelligence artificielle.

<!-- cSpell:locale fr -->
<!-- cSpell:ignore convert currency edit expense expenses pubspec mov -->
