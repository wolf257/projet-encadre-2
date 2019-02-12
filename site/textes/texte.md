* Le projet

Bienvenue. Ceci est un site créé dans le cadre du cours de projet encadré du second semestre de M1 Traitement Automatique du Langage.

Nous avions déjà réalisé un projet au premier semestre (voir /lien-site/, /lien-blog) sur la perception du viol sur le web. Au niveau technique, il s'agissait d'utiliser les languages bash et python pour aspirer des pages en plusieurs langues, traiter les problèmes d'encodage, puis extraire et analysé des motifs. 

Dans celui-ci, il s'agira, comme mentionné dans la page du cours, de :

`Mise en oeuvre d'une chaîne de traitement textuel semi-automatique, de la récupération des données à leur présentation.
Ce cours posera d'abord la question des objectifs linguistiques à atteindre (lexicologie, recherche d'information, traduction...) et fera appel aux méthodes et outils informatiques nécessaires à leur réalisation (récupération de corpus, normalisation des textes, segmentation, étiquetage, extraction, structuration et présentation des résultats...).
Ce cours sera aussi l'occasion d'une évaluation critique des résultats obtenus, d'un point de vue quantitatif et qualitatif.`

* Les données

Nos données consisteront en fils RSS issus du journal Le Monde. Les fils ont été récupérés par les soins du Pr Fleury en grande partie, grâce à un script bash et perl, activité par cron (/lien/) chaque jour de l'année 2018, à 19h. Ainsi, il a mis à notre disposition un dossier contenant les 17 fils d'actualité du journal (/img/).

Un dossier contenant les fils d'une année constitue une arborescence organisée de la façon suivante :

(/img/)

Nous avons décidé, en tant que groupe de nous concentrer sur trois fils :
- Technologie : 0,2-651865,1-0,0
- Livre : 0,2-3260,1-0,0
- Entreprises (? à confirmer) : 0,2-3234,1-0,0

Pour atteindre notre objectif, nous allons utilisé différentes BAO.


* Quelques définitions

- Bao : Boite à outils

-- à remplir --

- RSS :

-- à remplir --


* Plan de travail

** BaO 1 : script perl

** BaO 2 : étiquettage

** BaO 3 : Extraction de patrons

** BaO 4 : Visualisation
